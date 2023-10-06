=begin
If you have docker installed, and this file is called test_bg_scores.rb
and lives in the current directory, then you can run:

docker run --rm \
  --volume=./app/sum.rb:/tmp/sum.rb:ro \
  --volume=./app/bg_scores.rb:/tmp/bg_scores.rb:ro \
  --volume=./app/test_bg_scores.rb:/tmp/test_bg_scores.rb:ro \
  ruby:alpine ruby /tmp/test_bg_scores.rb

=end

require_relative 'bg_scores'
require_relative 'sum'

L1_X = 3
L1_Y = 5
L1_OTHER = 1

def test_level_1
  a,b,c,d = blah('XYYYY'), blah('XXYYY'), blah('berty'), blah('xxyyx')
  scores = bg_scores(level=1, sentence=nil, profound=nil, a,b,c,d)
  assert_equal([L1_X+L1_Y*4, L1_X*2+L1_Y*3, L1_OTHER*5, L1_OTHER*5], scores, "11")
  assert_equal([23, 21, 5, 5], scores, "12")
  assert_equal(total=54, sum(scores), "13")
  total
end

def test_level_1_invalid_letter
  a,b,c,d = blah('&YYYY'), blah('_XYYY'), blah('be*ty'), blah('xxy+x')
  scores = bg_scores(level=1, sentence=nil, profound=nil, a,b,c,d)
  sa = -1 + L1_Y*4
  sb = -1 + L1_X + L2_Y*3
  sc = -1 + L1_OTHER*4
  sd = -1 + L1_OTHER*4
  assert_equal([sa, sb, sc, sd], scores, "bad1-1")
  assert_equal([19, 17, 3, 3], scores, "bad1-2")
end

L2_X = L1_X
L2_Y = L1_Y
L2_x = 4
L2_y = 6
L2_g = 10
L2_OTHER = 2

def test_level_2
  a,b,c,d = blah('XxuyY'), blah('gobby'), blah('berty'), blah('grogs')
  scores = bg_scores(level=2, sentence=nil, profound=nil, a,b,c,d)
  assert_equal([L2_x+L2_X+L2_OTHER+L2_y+L2_Y, L2_g+L2_y+L2_OTHER*3, L2_OTHER*4+L2_y, L2_g*2+L2_OTHER*3], scores, "21")
  assert_equal([20, 22, 14, 26], scores, "22")
  assert_equal(total=82, sum(scores), "23")
  total
end

def test_level_2_invalid_letter
  a,b,c,d = blah('&uxyY'), blah('_obby'), blah('be*ty'), blah('gr+gs')
  scores = bg_scores(level=2, sentence=nil, profound=nil, a,b,c,d)
  sa = -2 + L2_OTHER + L2_x + L2_y + L2_Y
  sb = -2 + L2_OTHER*3 + L2_y
  sc = -2 + L2_OTHER*3 + L2_y
  sd = -2 + L2_OTHER*2 + L2_g*2
  assert_equal([sa, sb, sc, sd], scores, "bad2-1")
  assert_equal([15, 10, 10, 22], scores, "bad2-2")
end

L3_X = L2_X
L3_Y = L2_Y
L3_x = L2_x
L3_y = L2_y
L3_g = L2_g
L3_C = 20
L3_A = 30
L3_S = 40
L3_O = 50
L3_M = 60
L3_OTHER = 3

def test_level_3
  a,b,c,d = blah('XxuyY'), blah('gOCby'), blah('bArMy'), blah('grogS')
  scores = bg_scores(level=3, sentence=nil, profound=nil, a,b,c,d)
  assert_equal([L3_X+L3_x+L3_OTHER+L3_y+L3_Y,
                L3_g+L3_O+L3_C+L3_OTHER+L3_y,
                L3_OTHER+L3_A+L3_OTHER+L3_M+L3_y,
                L3_g+L3_OTHER+L3_OTHER+L3_g+L3_S], scores, "31")
  assert_equal([21, 89, 102, 66], scores, "32")
  assert_equal(total=278, sum(scores), "33")
  total
end

def test_level_3_invalid_letter
  a,b,c,d = blah('&XxyY'), blah('gOC*y'), blah('bA%My'), blah('gr+gS')
  scores = bg_scores(level=3, sentence=nil, profound=nil, a,b,c,d)
  sa = -3 + L3_X + L3_x + L3_y + L3_Y
  sb = -3 + L3_g + L3_O + L3_C + L3_y
  sc = -3 + L3_OTHER + L3_A + L3_M + L3_y
  sd = -3 + L3_g*2 + L3_OTHER + L3_S
  assert_equal([sa, sb, sc, sd], scores, "bad3-1")
  assert_equal([15, 83, 96, 60], scores, "bad3-2")
end

def test_level_4
  multiplier = 10
  a,b,c,d = blah('XxuyY'), blah('gOCby'), word('bArMy'), blah('grogS')
  scores = bg_scores(level=4, sentence=nil, profound=nil, a,b,c,d)
  assert_equal([L3_X+L3_x+L3_OTHER+L3_y+L3_Y,
                L3_g+L3_O+L3_C+L3_OTHER+L3_y,
                (L3_OTHER+L3_A+L3_OTHER+L3_M+L3_y) * multiplier,
                L3_g+L3_OTHER+L3_OTHER+L3_g+L3_S], scores, "41")
  assert_equal([21, 89, 1020, 66], scores, "42")
  assert_equal(total=1196, sum(scores), "43")
  total
end

def test_level_5
  multiplier = 10*10
  a,b,c,d = word('hello'), word('world'), word('bArMy'), word('gameS')
  scores = bg_scores(level=5, sentence=true, profound=nil, a,b,c,d)
  assert_equal([L3_OTHER*5 * multiplier,
                L3_OTHER*5 * multiplier,
                (L3_OTHER+L3_A+L3_OTHER+L3_M+L3_y) * multiplier,
                (L3_g+L3_OTHER*3+L3_S) * multiplier],
                scores, "51")
  assert_equal([1500, 1500, 10200, 5900], scores, "52")
  assert_equal(total=19100, sum(scores), "53")
  total
end

def test_level_6
  multiplier = 10*10*10
  a,b,c,d = word('wrong'), word('wordS'), word('SCore'), word('SMall')
  scores = bg_scores(level=6, sentence=nil, profound=true, a,b,c,d)
  assert_equal([(L3_OTHER*4+L3_g) * multiplier,
                (L3_OTHER*4+L3_S) * multiplier,
                (L3_OTHER*3+L3_S+L3_C) * multiplier,
                (L3_OTHER*3+L3_S+L3_M) * multiplier],
                scores, "61")
  assert_equal([22000, 52000, 69000, 109000], scores, "62")
  assert_equal(total=252000, sum(scores), "63")
  total
end

def test_level_6_not_profound_drops_back_to_level_5_scores
  multiplier = 10*10
  a,b,c,d = word('wrong'), word('wordS'), word('SCore'), word('SMall')
  scores = bg_scores(level=6, sentence=true, profound=false, a,b,c,d)
  assert_equal([(L3_OTHER*4+L3_g) * multiplier,
                (L3_OTHER*4+L3_S) * multiplier,
                (L3_OTHER*3+L3_S+L3_C) * multiplier,
                (L3_OTHER*3+L3_S+L3_M) * multiplier],
                scores, "test_level_6_not_profound_drops_back_to_level_5_scores - 1")
  assert_equal([2200, 5200, 6900, 10900], scores, "test_level_6_not_profound_drops_back_to_level_5_scores - 2")
  assert_equal(total=25200, sum(scores), "test_level_6_not_profound_drops_back_to_level_5_scores - 3")
  total
end

def test_level_6_not_sentence_drops_back_to_level_4_scores
  multiplier = 10
  a,b,c,d = word('wrong'), word('wordS'), word('SCore'), word('SMall')
  scores = bg_scores(level=6, sentence=false, profound=false, a,b,c,d)
  assert_equal([(L3_OTHER*4+L3_g) * multiplier,
                (L3_OTHER*4+L3_S) * multiplier,
                (L3_OTHER*3+L3_S+L3_C) * multiplier,
                (L3_OTHER*3+L3_S+L3_M) * multiplier],
                scores, "test_level_6_not_sentence_drops_back_to_level_4_scores - 1")
  assert_equal([220, 520, 690, 1090], scores, "test_level_6_not_sentence_drops_back_to_level_4_scores - 2")
  assert_equal(total=2520, sum(scores), "test_level_6_not_sentence_drops_back_to_level_4_scores - 3")
  total
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def word(s)
  [ s, true ]
end

def blah(s)
  [ s, false ]
end

def assert_equal(expected, actual, msg = '')
  if !(expected === actual)
    puts "ERROR:#{msg}"
    puts "expected: #{expected.inspect}"
    puts "  actual: #{actual.inspect}"
    exit(42)
  end
end

def assert_sums(expected, scores)
  scores.size.times do |i|
    assert_equal(expected[i], sum(scores[i]))
  end
end

def sorted?(array)
  array.each_cons(2).all? { |a, b| (a <=> b) < 0 }
end

def test_scores_and_that_they_increase_as_levels_progress
  s1 = test_level_1
  s2 = test_level_2
  s3 = test_level_3
  s4 = test_level_4
  s5 = test_level_5
  s6 = test_level_6
  assert_equal(true, sorted?([s1, s2, s3, s4, s5, s6]), 'not sorted!')
end

test_scores_and_that_they_increase_as_levels_progress

test_level_1_invalid_letter
test_level_2_invalid_letter
test_level_3_invalid_letter

test_level_6_not_profound_drops_back_to_level_5_scores
test_level_6_not_sentence_drops_back_to_level_4_scores
p("All tests passed")