/******************************************************************************\
 * Corpus - Kayboard Assesment API
 * (c) 2013 Tab Computing
 *     All Rights Reserved
\******************************************************************************/

package keyboard

import (
  "fmt"
  "time"
  "math/rand"
)

//
// Must be initialized with an Array of Keyboards.
//
// pop - initial population
//
func Evolve(pop []Keyboard, count int) []Keyboard {
  rand.Seed(time.Now().Unix())

  size := MINIMUM_POPULTATION
  best := 0

  for i := 0; i < count; i++ {
    fmt.Printf("Generation %d @ %s\n", i+1, time.Now())

    pop = append(pop, breed(pop)...)
    pop = natural_selection(pop, size)

    if best < pop[0].Score {
      best = pop[0].Score
      size = MINIMUM_POPULTATION
    } else {
      size = size + 2
    }

    pop[0].Display()
  }

  return pop
}

//
// Generate a population.
//
func Population() []Keyboard {
  var pop []Keyboard

  if settings.Numbered {
    pop = []Keyboard{random_keyboard(), makeKeyboard(layout_numeric_compromise)}
  } else {
    pop = []Keyboard{random_keyboard(), makeKeyboard(layout_advanced_acoustic)}
  }
  return pop
}

//
//
//
const MINIMUM_POPULTATION = 16

//
//
//
func minimum_population() int {
  return MINIMUM_POPULTATION
}

/*
//
// Concat two populations into one.
//
func concat_populations(p1, p2 []Keyboard) []Keyboard {
  pop := make([]Keyboard, len(p1) + len(p2))
  copy(pop, p1)
  copy(pop[len(p1):], p2)
  return pop
}
*/

//
// Selects population to survive and recombine.
//
func natural_selection(pop []Keyboard, max int) []Keyboard {
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
func sort_population(pop []Keyboard) []Keyboard {
  return sort_keyboards(pop)
}

//
// Sex!
//
func breed(pop []Keyboard) []Keyboard {
  if settings.Debug { fmt.Printf("Breeding %d layouts\n", len(pop)) }

  var child Keyboard
  var gen []Keyboard

  rp := randomize_population(pop)

  for i := 1; i < len(rp); i++ {
    child = cross(rp[i-1], rp[i])
    gen   = append(gen,child)
  }

  return gen
}

//
// Crossbreed two Keyboards.
//
func cross(mother Keyboard, father Keyboard) Keyboard {
  genes := make([]string, len(mother.Layout))
  copy(genes, mother.Layout)

  offset := 0; if settings.Numbered { offset = 9 }

  s := rand.Intn(len(genes) - offset) + offset
  n := rand.Intn(len(genes) - offset) + offset

  if (s < 9 || n < 9) {
    fmt.Printf("How did it get under 9? %d %d", s, n)
  }

  if s > n { s, n = n, s }

  var c string
  var x int

  for i := s; i <= n; i++ {
    c = father.Layout[i]
    x = index(genes, c)

    if settings.Numbered && x < 9 {
      fmt.Printf("ERROR: Index is under 9: %s, %d!\n", c, x)
    }

    if x > -1 {
      genes[x] = genes[i]
      genes[i] = c
    }
  }

  dups := duplicates(genes)
  if len(dups) > 0 {
    fmt.Printf("ERROR: duplicates from sex!\n%s\n%s\n%s\n%s", dups, mother.Layout, father.Layout, genes)
  }

  // mutate the genes and return as a new Keyboard
  return makeKeyboard(mutate(genes))
}

//
// Evolutionary mutation, by swapping two positions.
//
func mutate(layout []string) []string {
  // 50% of the time no mutations occur
  if (rand.Intn(2) == 0) { return layout }

  offset := 0; if settings.Numbered { offset = 9 }

  var mutant []string = layout

  // number of mutations
  n := rand.Intn(len(layout))

  for i := 0; i < n; i++ {
    i1 := rand.Intn(len(layout) - offset) + offset
    i2 := rand.Intn(len(layout) - offset) + offset

    // numeric boards should not touch the top row
    if settings.Numbered && (i1 < 9 || i2 < 9) {
      fmt.Printf("ERROR: Index is under 9: %d %d", i1, i2)
    }

    mutant = swap(layout, i1, i2)
  }

  dups := duplicates(mutant)
  if len(dups) > 0 {
    fmt.Printf("ERROR: Duplicate letter from mutation!\n%s", mutant)
  }

  return mutant
}

//
// Deprecated: Swap populations.
//
func swap_population(a []Keyboard, i1 int, i2 int) []Keyboard {
  n := make([]Keyboard, len(a))
  copy(n, a)
  n[i1], n[i2] = a[i2], a[i1]
  return n
}

//
// Randomize the order of a population.
//
func randomize_population(pop []Keyboard) []Keyboard {
  for i := range pop {
      j := rand.Intn(i + 1)
      pop[i], pop[j] = pop[j], pop[i]
  }
  return pop
}


// TODO: Save and restore current population.

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

