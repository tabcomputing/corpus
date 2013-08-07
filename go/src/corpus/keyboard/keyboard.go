/******************************************************************************\
 * Corpus - Kayboard Assesment API
 * (c) 2013 Tab Computing
 *     All Rights Reserved
\******************************************************************************/

package keyboard

import (
  "fmt"
  "sort"
)

//
// Keyboard structure consists of a layout and a score.
//
type Keyboard struct {
  Layout []string
  Score  int
}

//
// Score a keyboard.
//
func Score(keyboard Keyboard) int {
  return score_layout(keyboard.Layout)
}

//
// Alphabet.
//
var alphabet = []string{ 
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
  "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}

//
// Numbers
//
var numbers = []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

//
// Common letter pairs.
//
var pairs = []string{"wh", "ch", "ph", "th", "gh", "sh", "dj", "ng", "er", "an"}

//
// Letters with bi-lateral symmetries
//
var symmetries = [][]string{
  {"t","d"},{"p","b"},{"k","g"},{"f","v"},{"s","z"},{"c","x"},{"sh","j"},{"ch","dj"},
  {"m","w"},{"n","r"},{"l","r"},{"n","y"},{"ng","y"},
  {"i","e"},{"o","a"},
  {"p","f"},{"b","v"},{"t","sh"},{"s","th"},{"d","j"},{"k","q"},{"g","gh"},{"g","x"},
  {"s","c"},{"z","x"}}

//
//
//
var symmetric_positions = [][]int{
  { 0, 8},{ 1, 7},{ 2, 6},{ 3, 5},
  { 9,17},{10,16},{11,15},{12,14},
  {18,26},{19,25},{20,24},{21,23},
  {27,35},{28,34},{29,33},{30,32},
  {10,21},{16,23},{12,19},{14,25}}

// { 0,27},{1, 28},{2, 29},{ 3,30},{ 4,31},{ 5,32},{ 6,33},{ 7,34},{ 8,35},
// { 9,18},{10,19},{11,20},{12,21},{13,22},{14,23},{15,24},{16,25},{17,26}

//
// Ergonmic (very ergonomic but maybe too weird)
//
var layout_numeric_point = []string{
   "4", "x", "v",  "j", "5", "r",  "k", "g", "0",
   "z", "p", "u",  "l", "y", "b",  "c", "f", "6",
   "7", "n", "h",  "d", "8", "w",  "q", "m", "9",
   "1", "a", "e",  "t", "2", "s",  "i", "o", "3" }

var layout_topside_compromise = []string{
  "gh","th","ng", "4", "ch","wh", "7", "sh","9",
  "u", "b", "p",  "r", "l", "w",  "f", "v", "0",
  "g", "h", "n",  "k", "j", "q",  "m", "y", "x",
  "d", "t", "e",  "a", "c", "o",  "i", "s", "z" }

var layout_numeric_compromise = []string{
  "1", "2", "3",  "4", "5", "6",  "7", "8", "9", "u", "b", "p",  "r", "l", "w",  "f", "v", "0",
  "g", "h", "n",  "k", "j", "q",  "m", "y", "x",
  "d", "t", "e",  "a", "c", "o",  "i", "s", "z" }

var layout_topside_alternate = []string{
  "gh","th","ng", "4","ch", "6",  "wh","sh","9",
  "g", "k", "r",  "u", "l", "0",  "w", "q", "x",
  "b", "p", "n",  "h", "j", "y",  "m", "f", "v",
  "d", "t", "e",  "a", "c", "o",  "i", "s", "z" }

var layout_numeric_alternate = []string{
  "1", "2", "3",  "4", "5", "6",  "7", "8", "9",
  "g", "k", "w",  "c", "r", "j",  "y", "q", "x",
  "b", "p", "m",  "h", "l", "0",  "n", "f", "v",
  "d", "t", "e",  "a", "u", "i",  "o", "s", "z" }

var layout_topside_third = []string{
  "gh","qu","ng", "th","ch","sh", "wh","ph","-",
  "q", "g", "k",  "n", "r", "l",  "w", "f", "0",
  "x", "i", "h",  "d", "j", "z",  "p", "b", "v",
  "y", "e", "a",  "t", "c", "s",  "m", "o", "u" }

// Ergonomic (my original hand made version)
var layout_numeric_original = []string{
  "1", "2", "3",  "4", "5", "6",  "7", "8", "9",
  "z", "g", "k",  "n", "v", "m",  "w", "r", "0",
  "x", "t", "s",  "b", "j", "d",  "f", "c", "q",
  "p", "a", "e",  "o", "u", "h",  "i", "l", "y" }

var layout_topside_another = []string{
  "gh","ph","ng", "th","sh","wh", "ch","8", "qu",
  "z", "p", "u",  "l", "v", "f",  "c", "b", "0",
  "x", "h", "n",  "d", "j", "w",  "m", "r", "q",
  "g", "a", "e",  "t", "y", "s",  "i", "o", "k" }

var layout_numeric_phonetic = []string{
  "1", "2", "3",  "4", "5", "6",  "7", "8", "9",
  "0", "u", "y",  "n", "r", "l",  "m", "h", "w",
  "g", "e", "x",  "d", "j", "z",  "b", "i", "v",
  "k", "a", "q",  "t", "c", "s",  "p", "o", "f" }

var layout_topside_phonetic = []string{
  "gh","2", "3", "th","ch","sh", "ph", "8", "wh",
  "0", "u", "y",  "n", "r", "l",  "m", "h", "w",
  "g", "e", "x",  "d", "j", "z",  "b", "i", "v",
  "k", "a", "q",  "t", "c", "s",  "p", "o", "f" }

var layout_advanced_symmetric = []string{
  "f", "sh","qu", "m", "wh","w",  "gh","j", "v",
  "c", "ch","th", "n", "l", "r",  "th","dj","x",
  "p", "t", "k",  "ng","u", "y",  "g", "d", "b",
  "ph","o", "s",  "i", "h", "e",  "z", "a", "'" }

var layout_advanced_acoustic = []string{
  "f", "ch","qu", "wh","h", "er", "'", "l", "an",
  "v", "th","gh", "w", "r", "y",  "m", "n", "ng",
  "u", "o", "a",  "z", "j", "x",  "b", "d", "g",  
  "y", "i", "e",  "s", "sh","c",  "p", "t", "k" }

var layout_advanced_articulate = []string{
   "x", "g", "ng", "o","wh", "i",  "m", "b", "v",
   "q", "k", "y",  "-", "-", "-",  "w", "p", "f",
   "j", "d", "n",  "-", "-", "-",  "l", "z", "th",
   "sh","t", "r",  "a", "u", "e",  "h", "s", "c" }

var layout_advanced_plus = []string{
  "x", "q", "y",  "o", "wh","i",  "w", "f", "v",
  "g", "k","ng",  "-", "-", "-",  "m", "p", "b",
  "j", "sh","r",  "-", "-", "-",  "h", "th","c",
  "d", "t", "n",  "a", "u", "e",  "l", "s", "z" }

//
// Make a Keyboard given a layout.
//
func makeKeyboard(layout []string) Keyboard {
  return Keyboard{layout, score_layout(layout)}
}

//
// Display a Keyboard.
//
func (keyboard Keyboard) Display() {
  lay := keyboard.Layout
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[0:9])...)
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[9:18])...)
  fmt.Println("------------------------------" )
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[18:27])...)
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[27:36])...)
  fmt.Printf("(Score: %d)\n\n", keyboard.Score)
}

//
// Array of predefined keyboards.
//
func PredefinedKeyboards() map[string]Keyboard {
  layouts := PredefinedLayouts()
  keyboards := make(map[string]Keyboard, len(layouts))

  for name, layout := range layouts {
    keyboards[name] = makeKeyboard(layout)
  }

  return keyboards
}

//
// Array of predefined layout letters.
//
func PredefinedLayouts() map[string][]string {
  layouts := map[string][]string{
    "Numeric Point":       layout_numeric_point,
    "Numeric Original":    layout_numeric_original,
    "Numeric Compromise":  layout_numeric_compromise,
    "Numeric Alternate":   layout_numeric_alternate,
    "Numeric Phonetic":    layout_numeric_phonetic,
    "Topside Compromise":  layout_topside_compromise,
    "Topside Alternate":   layout_topside_alternate,
    "Topside Thrid":       layout_topside_third,
    "Topside Another":     layout_topside_another,
    "Advanced Symmetric":  layout_advanced_symmetric,
    "Advanced Articulate": layout_advanced_articulate,
    "Advanced Plus":       layout_advanced_plus }
  return layouts
}

//
//
//
func random_keyboard() Keyboard {
  if settings.Numbered {
    return makeKeyboard(append(numbers, randomize(alphabet)...))
  } else {
    return makeKeyboard(append(pairs, randomize(alphabet)...))
  }
}

//
// Relative scores for difference priciples of keyboard design.
//
var scores = map[string]float64{
  "base":           0.0,
  "primary":       50.0,
  "point":         50.0,
  "nonpoint":     -50.0,
  "pinky":        -25.0,
  "horizontal":    50.0,
  "vertical":    -100.0,
  "double_tap":   -75.0,
  "distant":      -25.0,
  "concomitant":   50.0,
  "symmetry":      10.0 }

//
// Score a layout's letters.
//
func score_layout(layout []string) int {
  var sum float64 = 0.0
  for word, rank := range words() {
    sum = sum + score_word(layout, word, rank)
  }
  if settings.Symmetric {
    sum = sum + (symmetry(layout) * scores["symmetry"])
  }
  return int(sum)
}

//
// Score a word.
//
func score_word(layout []string, word string, rank float64) float64 {
  letters := word_letters(layout, word)

  var score float64 = 0.0
  var last string 

  for index, letter := range letters {
    significance := 1.0 / float64(index + 1)  //weigh(letter, float64(index) * 100)  // first letters are more significant
    if member(layout, letter) {
      score = score + (score_letter(layout, letter, last) * significance)
    } else {
      //score = score - deduction  // this generally should never happen
    }
    last = letter
  }

  // weight the score by the word ranking
  return score * rank
}

//
// Scire a letter in a word.
//
func score_letter(layout []string, letter, last string) float64 {
  score := scores["base"]

  if is_primary(layout, letter)    { score = score + scores["primary"]    }
  if is_point(layout, letter)      { score = score + scores["point"]      }
  if is_nonpoint(layout, letter)   { score = score + scores["nonpoint"]   }
  if is_pinky(layout, letter)      { score = score + scores["pinky"]      }
  if is_horizontal(layout, letter) { score = score + scores["horizontal"] } 
  if is_vertical(layout, letter)   { score = score + scores["vertical"]   }
  if is_doubletap(layout, letter)  { score = score + scores["double_tap"] }
  if is_distant(layout, letter)    { score = score + scores["distant"] }

  if last != "" && is_concomitant(layout, last, letter) {
    score = score + scores["concomitant"]
  }

  return weigh(letter, score)
}

//
// Split a word into an array of available letters
// based on the lay.
//
func word_letters(lay []string, word string) []string {
  chars := []string{}

  last   := ""
  pair   := ""
  letter := ""

  for _, r := range word {
    letter = string(r)
    pair   = last + letter
    if member(lay, pair) {
      chars = append(chars, pair)
    } else {
      chars = append(chars, letter)
    }
    last = letter
  }

  return chars
}

//
// Weigh a letter based on it's corpus rank.
//
func weigh(letter string, score float64) float64 {
  letters := letters()
  rank    := letters[letter]
  //if rank == 0.0 {
  //  return score * 0.5  // half if not found ?
  //} else {
    return score * rank
  //}
}

//
// Anything starting on the primary row (the bottom row) is better.
//
func is_primary(layout []string, letter string) bool {
  i := index(layout, letter)
  return i >= 18 && i <= 35
}

var indexes_point = []int{12, 15, 19, 20, 27, 28, 29, 30, 33}

//
// Any action that keeps the first finger on the lower left key is
// better (from right handed perspective).
//
func is_point(layout []string, letter string) bool {
  i := index(layout, letter)
  return member_int(indexes_point, i)
}

var indexes_nonpoint = []int{0, 1, 2, 9, 10, 11, 3, 6, 18, 21, 24}

//
// Any action that forces the first finger to move up is bad
// (from right handed perspective).
//
func is_nonpoint(layout []string, letter string) bool {
  i := index(layout, letter)
  return member_int(indexes_nonpoint, i)
}

var indexes_pinky = []int{6, 7, 8, 15, 16, 17, 20, 23, 26}

//
// Having to move up the weak finger sucks too.
//
func is_pinky(layout []string, letter string) bool {
  i := index(layout, letter)
  return member_int(indexes_pinky, i)
}

//
// Horizontal actions are generally better than diagonal ones.
//
func is_horizontal(layout []string, letter string) bool {
  i := index(layout, letter)
  return (i >= 0  && i <= 8) || (i >= 27 && i <= 35)
}

var indexes_vertical = []int{9, 13, 17, 18, 22, 26}

//
// Vertical actions are the worst.
//
func is_vertical(layout []string, letter string) bool {
  i := index(layout, letter)
  return member_int(indexes_vertical, i)
}

var indexes_doubletap = []int{0, 4, 8, 27, 31, 35}

//
// Letters that require a double tap of the same key aren't ideal either.
//
func is_doubletap(layout []string, letter string) bool {
  i := index(layout, letter)
  return member_int(indexes_doubletap, i)
}

//
// Letters that require distant keystrokes are not so good.
//
var indexes_distant = []int{2, 6, 11, 15, 20, 24, 29, 33}
func is_distant(layout []string, letter string) bool {
  i := index(layout, letter)
  return member_int(indexes_distant, i)
}

//
// Too letters are concomitant if the first letter ends on the key
// that the second letter begins. This is a good thing.
//
func is_concomitant(layout []string, letter1, letter2 string) bool {
  var i1 int = index(layout, letter1)
  var i2 int = index(layout, letter2)

  var c1 int
  var c2 int

  if i1 >= 0 && i2 >= 0 {
    c1 = i1 % 6
    c2 = i2 / 6
    return c1 == c2
  } else {
    return false
  }
}

//
// Counts the number of symmetries in a layout.
//
func symmetry(layout []string) float64 {
  cnt := 0.0
  for _, p := range symmetric_positions {
    for _, q := range symmetries {
      if (layout[p[0]] == q[0] && layout[p[1]] == q[1]) ||
         (layout[p[0]] == q[1] && layout[p[1]] == q[0]) {
        cnt++
      }
    } 
  }
  return cnt
}

//
//
//
func member_int(list []int, a int) bool {
  for _, b := range list {
    if b == a {
      return true
    }
  }
  return false
}

//
// Sort population, highest fitness first. 
//
func sort_keyboards(pop []Keyboard) []Keyboard {
  sort.Sort(ByScore(pop))
  return pop
}

//
//
//
func sort_keyboards_slow(pop []Keyboard) []Keyboard {
  for i := 0; i < len(pop) - 1; i++ {
    for j := 0; j < len(pop) - 1; j++ {
      if pop[j].Score < pop[j+1].Score {
        pop[j], pop[j+1] = pop[j+1], pop[j]
      }
    }
    if pop[i].Score < pop[i+1].Score {
      pop[i], pop[i+1] = pop[i+1], pop[i]
    }
  }
  return pop
}

//
// Sorting of Keyboards by score.
//
type ByScore []Keyboard
func (s ByScore) Len() int {
  return len(s)
}
func (s ByScore) Swap(i, j int) {
  s[i], s[j] = s[j], s[i]
}
func (s ByScore) Less(i, j int) bool {
  return s[i].Score > s[j].Score
}

