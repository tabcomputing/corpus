/******************************************************************************\
 * Corpus - Kayboard Assesment API
 * (c) 2013 Tab Computing
 *     All Rights Reserved
\******************************************************************************/

package corpus

import (
  "fmt"
  "os"
  "bufio"
  "strings"
  "strconv"
)

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
var letters_cache map[string]float64

// Letters and their ranks.
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
// Cache for saved layouts.
//
var saved_cache [][]string

//
//
//
func saved_layouts() [][]string {
  if saved_cache == nil {
    saved_cache = load_layouts()
  }
  return saved_cache
}

//
//
//
func load_layouts() [][]string {
  layouts := [][]string{}
  layout  := []string{}
  counter := 0

  var entry []string

  file, err := os.Open("data/saves.dat") // "data/saves.dat"
  if err != nil {
    fmt.Fprintln(os.Stderr, "file not found:", err)
  }

  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
     entry = strings.Fields(scanner.Text())
     if len(entry) != 0 && entry[0] != "#" {
       if counter == 3 {
         layout  = append(layout, entry...)
         layouts = append(layouts, layout)
         layout  = []string{}
         counter = 0
       } else {
         layout = append(layout, entry...)
         counter = counter + 1
       }
     }
  }
  if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading standard input:", err)
  }

  return layouts
}
