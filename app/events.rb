require 'json'
require_relative 'sum'

def save_decisions(org_name, level, decisions, scores)
  events = read_events(org_name)
  if events === []
    previous_total = 0
  else
    previous_total = events[-1]["running_total"]
  end
  events.append({
    "type": "decision",
    "timestamp": Time.now.to_i,
    "level": level,             # 1
    "decisions": decisions,     # ["XXXXX","YYYYY","sdfsd","sdfse"]
    "scores": scores,           # [15,25,5,5]
    "sub_total": sum(scores),   # 50
    "running_total": previous_total + sum(scores)
  })
  write_events(org_name, events)
end

def pay(org_name, level)
  events = read_events(org_name)
  total = events === [] ? 0 : events[-1]["running_total"]
  if total < 20
    "Org's total==#{total} is less than minimum cost (20)"
  else
    cost = (total * 0.3).to_i
    cost = [20, cost].max
    events.append({
      "type": "consulting",
      "timestamp": Time.now.to_i,
      "level": level,
      "cost": cost,
      "running_total": total - cost
    })
    write_events(org_name, events)
    "" # return empty string on success
  end
end

def read_events(org_name)
  JSON.parse(File.read(events_filename(org_name)))
end

def write_events(org_name, events)
  File.write(events_filename(org_name), JSON.pretty_generate(events))
end

def events_filename(org_name)
  "/app/scores/#{org_name}/events.json"
end
