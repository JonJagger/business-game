
# -----------------------------------------------------------------------
# Algorithm for scoring decisions played in variation of Jerry Weinberg's XY Business Game
# Partially described in Experiential Learning: Volume 4. Sample Exercises
# Available on LeanPub:
#   https://leanpub.com/experientiallearning4sampleexercises

def bg_scores(level, sentence, rhymes, a, b, c, d)
  org_score(level, sentence, rhymes, a, b, c, d)
end

def org_score(level, is_sentence, rhyming, *decisions)
  letters,are_words = decisions.transpose
  letters.map!{ |word| word.chars }
  if level == 1
     level_1_scores(*letters)
  elsif level == 2
     level_2_scores(*letters)
  elsif level == 3
     level_3_scores(*letters)
  elsif level == 4
     level_4_scores(*letters, *are_words)
  elsif level == 5
     level_5_scores(is_sentence, *letters, *are_words)
  elsif level == 6
     level_6_scores(rhyming, is_sentence, *letters, *are_words)
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def level_1_scores(a, b, c, d)
  [ level_1_section_score(a),
    level_1_section_score(b),
    level_1_section_score(c),
    level_1_section_score(d)
  ]
end

def level_1_section_score(section)
  sum(section.map{ |letter| level_1_letter_score(letter) })
end

ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

L1_DICT = { "X" => 3, "Y" => 5 }

def level_1_letter_score(letter)
  if L1_DICT.has_key?(letter)
    L1_DICT[letter]
  elsif ALPHABET.include?(letter)
    1
  else
    -1
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def level_2_scores(a, b, c, d)
  [ level_2_section_score(a),
    level_2_section_score(b),
    level_2_section_score(c),
    level_2_section_score(d)
  ]
end

def level_2_section_score(section)
  sum(section.map{ |letter| level_2_letter_score(letter) })
end

L2_DICT = L1_DICT.merge({ "x" => 4, "y" => 6, "g" => 10 })

def level_2_letter_score(letter)
  if L2_DICT.has_key?(letter)
    L2_DICT[letter]
  elsif ALPHABET.include?(letter)
    2
  else
    -2
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def level_3_scores(a, b, c, d)
  [ level_3_section_score(a),
    level_3_section_score(b),
    level_3_section_score(c),
    level_3_section_score(d)
  ]
end

def level_3_section_score(section)
  sum(section.map{ |letter| level_3_letter_score(letter) })
end

L3_DICT = L2_DICT.merge({"C" => 20, "A" => 30, "S" => 40, "O" => 50, "M" => 60})

def level_3_letter_score(letter)
  if L3_DICT.has_key?(letter)
    L3_DICT[letter]
  elsif ALPHABET.include?(letter)
    3
  else
    -3
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def level_4_scores(a, b, c, d, wa, wb, wc, wd)
  [ level_4_section_score(a, wa),
    level_4_section_score(b, wb),
    level_4_section_score(c, wc),
    level_4_section_score(d, wd)
  ]
end

def level_4_section_score(section, is_word)
  multiplier = is_word ? 10 : 1
  level_3_section_score(section) * multiplier
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def level_5_scores(is_sentence, a, b, c, d, wa, wb, wc, wd)
  if is_sentence  # To simplify submission at level 5
    wa = true
    wb = true
    wc = true
    wd = true
  end
  [ level_5_section_score(is_sentence, a, wa),
    level_5_section_score(is_sentence, b, wb),
    level_5_section_score(is_sentence, c, wc),
    level_5_section_score(is_sentence, d, wd)
  ]
end

def level_5_section_score(is_sentence, section, is_word)
  multiplier = is_sentence ? 10 : 1
  level_4_section_score(section, is_word) * multiplier
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def level_6_scores(rhyming, is_sentence, a, b, c, d, wa, wb, wc, wd)
  if rhyming
    is_sentence = true
  end
  if is_sentence
    wa = true
    wb = true
    wc = true
    wd = true
  end
  [ level_6_section_score(rhyming, is_sentence, a, wa),
    level_6_section_score(rhyming, is_sentence, b, wb),
    level_6_section_score(rhyming, is_sentence, c, wc),
    level_6_section_score(rhyming, is_sentence, d, wd)
  ]
end

def level_6_section_score(rhyming, is_sentence, section, is_word)
  multiplier = rhyming ? 10 : 1
  level_5_section_score(is_sentence, section, is_word) * multiplier
end


def sum(scores)
  scores.reduce(0,:+)
end

