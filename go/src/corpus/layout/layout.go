/* Corpus - Layout API
 * (c) 2013 Tab Computing
 */
package layout

import (
  "fmt"
  "os"
  "bufio"
  "strings"
  "strconv"
  "math/rand"
)

// Debug mode.
var debug bool = true

// Alphabet.
var alphabet = []string{ 
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
  "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}

// Numbers.
var numbers = []string{"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

// Common letter pairs.
var pairs = []string{"wh", "ch", "ph", "th", "gh", "sh", "dj", "ng", "er", "an"}

// Ergonmic (very ergonomic but maybe too weird)
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
// Keyset structure consists of a layout and a score.
//
type Keyset struct {
  layout []string
  Score  int
}

//
// Make a Keyset given a layout.
//
func makeKeyset(layout []string) Keyset {
  return Keyset{layout, score_layout(layout)}
}

//
// Display a Keyset.
//
func (keyset Keyset) Display() {
  lay := keyset.layout
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[0:9])...)
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[9:18])...)
  fmt.Println("------------------------------" )
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[18:27])...)
  fmt.Printf("%2s %2s %2s | %2s %2s %2s | %2s %2s %2s\n", iface(lay[27:36])...)
  fmt.Printf("(Score: %d)\n\n", keyset.Score)
}

//
// Array of predefined keysets.
//
func PredefinedKeysets() map[string]Keyset {
  layouts := PredefinedLayouts()
  keysets := make(map[string]Keyset, len(layouts))

  for name, layout := range layouts {
    keysets[name] = makeKeyset(layout)
  }

  return keysets
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
// Generate a population.
//
func Population(numeric bool) []Keyset {
  var pop []Keyset

  if numeric {
    top_numbers = true
    pop = []Keyset{random_keyset(true), makeKeyset(layout_numeric_compromise)}
  } else {
    top_numbers = false
    pop = []Keyset{random_keyset(false), makeKeyset(layout_advanced_acoustic)}
  }
  return pop
}

//
//
//
func random_keyset(numeric bool) Keyset {
  if numeric {
    return makeKeyset(append(numbers, randomize(alphabet)...))
  } else {
    return makeKeyset(append(pairs, randomize(alphabet)...))
  }
}

//
//
//
var words_cache map[string]float64

//
// Top 1000 words with ranks.
//
func words() map[string]float64 {
    // if empty ?
    if words_cache == nil {
        words_cache = load_words(1000)
    }
    return words_cache
}

//
// Load words with ranks from words.dat cache file.
//
func load_words(max int) map[string]float64 {
  words := make(map[string]float64)

  var entry []string
  var rank float64 = 0.0

  file, err := os.Open("data/words.dat")
  if err != nil {
    fmt.Fprintln(os.Stderr, "file not found:", err)
  }

  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
     entry = strings.Fields(scanner.Text())
     rank, _ = strconv.ParseFloat(entry[0], 32)
     words[entry[1]] = float64(rank)
  }
  if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading standard input:", err)
  }

  return words
}

//
//
//
var letters_cache map[string]float64

//
// Letters and their ranks.
//
func letters() map[string]float64 {
  // if empty ?
  if letters_cache == nil {
    letters_cache = load_letters()
  }
  return letters_cache
}

//
// Load letters with ranks from letters.dat cache file.
//
func load_letters() map[string]float64 {
  letters := make(map[string]float64)

  var entry []string
  var rank float64 = 0.0

  file, err := os.Open("data/letters.dat")
  if err != nil {
    fmt.Fprintln(os.Stderr, "file not found:", err)
  }

  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
     entry = strings.Fields(scanner.Text())
     rank, _ = strconv.ParseFloat(entry[0], 32)
     letters[entry[1]] = float64(rank)
  }
  if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading standard input:", err)
  }

  return letters
}

//
// A layout is top-numbered if the top row is always numbers.
//
var top_numbers bool = true

//
//
//
var scores = map[string]float64{
  "base":           0.0,
  "primary":       50.0,
  "point":         50.0,
  "nonpoint":     -50.0,
  "pinky":        -25.0,
  "horizontal":    50.0,
  "vertical":    -150.0,
  "double_tap":  -100.0,
  "concomitant":   50.0 }

//
// Score a keyset.
//
func Score(keyset Keyset) int {
  return score_layout(keyset.layout)
}

//
// Score a layout's letters.
//
func score_layout(layout []string) int {
  var sum float64 = 0.0
  for word, rank := range words() {
    sum = sum + score_word(layout, word, rank)
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
// Must be initialized with an Array of "chromosomes". A chomosome object
// must implement the methods `fitness`, `recombine` and `mutate`.
//
// pop - initial population
//
func Evolve(pop []Keyset, max int) []Keyset {
  for i := 0; i < max; i++ {
    pop = append(pop, breed(pop)...)
    pop = natural_selection(pop, 32)
    pop[0].Display()
  }
  return pop
}

/*
//
// Concat two populations into one.
//
func concat_populations(p1, p2 []Keyset) []Keyset {
  pop := make([]Keyset, len(p1) + len(p2))
  copy(pop, p1)
  copy(pop[len(p1):], p2)
  return pop
}
*/

//
// Selects population to survive and recombine.
//
func natural_selection(pop []Keyset, max int) []Keyset {
  if len(pop) > max {
    return sort_population(pop)[0:max]
  } else {
    return sort_population(pop)
  }
}

//
// Sort population, highest fitness first. 
//
// TODO: This can be faster!
//
func sort_population(pop []Keyset) []Keyset {
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
// Sex!
//
func breed(pop []Keyset) []Keyset {
  if debug { fmt.Printf("Breeding %d layouts\n", len(pop)) }

  var chrom []string
  var child Keyset
  var gen []Keyset

  rp := randomize_population(pop)

  for i := 1; i < len(rp); i++ {
    chrom = cross(rp[i-1].layout, rp[i].layout)
    child = makeKeyset(mutate(chrom))
    gen = append(gen,child)
  }

  return gen
}

//
// Crossbreed two layouts.
//
func cross(mother []string, father []string) []string {
  child := make([]string, len(mother))
  copy(child, mother)

  offset := 0; if top_numbers { offset = 9 }

  s := rand.Intn(len(child) - offset) + offset
  n := rand.Intn(len(child) - offset) + offset

  if (s < 9 || n < 9) {
    fmt.Printf("How did it get under 9? %d %d", s, n)
  }

  if s > n { s, n = n, s }

  var c string
  var x int

  for i := s; i <= n; i++ {
    c = father[i]
    x = index(child, c)

    if x > -1 {
      child[x] = child[i]
      child[i] = c
    }
  }

  dups := duplicates(child)
  if len(dups) > 0 {
    fmt.Printf("ERROR: duplicates from sex!\n%s\n%s\n%s\n%s", dups, mother, father, child)
  }

  return child
}

//
// Evolutionary mutation, by swapping two positions.
//
func mutate(layout []string) []string {
  offset := 0; if top_numbers { offset = 9 }

  // 50% of the time no mutation occurs
  if (rand.Intn(2) == 0) { return layout }

  i1 := rand.Intn(len(layout) - offset) + offset
  i2 := rand.Intn(len(layout) - offset) + offset

  if (i1 < 9 || i2 < 9) {
    fmt.Printf("How did it get under 9? %d %d", i1, i2)
  }

  mutant := swap(layout, i1, i2)
  dups   := duplicates(mutant)

  if len(dups) > 0 {
    fmt.Printf("Duplicate letter from mutation!\n%s", mutant)
  }

  return mutant
}

//
// Swap populations.
//
func swap_population(a []Keyset, i1 int, i2 int) []Keyset {
  n := make([]Keyset, len(a))
  copy(n, a)
  n[i1], n[i2] = a[i2], a[i1]
  return n
}

//
// Randomize the order of a population.
//
func randomize_population(pop []Keyset) []Keyset {
  for i := range pop {
      j := rand.Intn(i + 1)
      pop[i], pop[j] = pop[j], pop[i]
  }
  return pop
}

/*
  // Returns a GeneticAlgorithm object with the generations
  // loaded from given files and with properties prop.
  // Files must contain the chromosomes in YAML format.
  def self.populate_from_file(filename, prop = {})
    GeneticAlgorithm.new(YAML.load(File.open(filename, 'r')), prop)
  end

  // Saves into filename and in yaml format the generation that matchs with given
  // generation number ( by default from last generation ).
  def save_population(filename)
    f = File.new(filename, "w")
    f.write(@population.to_yaml)
    f.close
  end

*/

