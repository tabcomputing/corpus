/* Corpus - Layout array helpers
 * (c) 2013 Tab Computing
 */
package layout

import (
    "math/rand"
)

//
//
//
func randomize(strings []string) []string {
    for i := range strings {
        j := rand.Intn(i + 1)
        strings[i], strings[j] = strings[j], strings[i]
    }
    return strings
}

/*
//
//
//
func concat(a, b []string) []string {
  ret := make([]string, len(a) + len(b))
  copy(ret, a)
  copy(ret[len(a):], b)
  return ret
}
*/

//
// Good lord, I have to write my own routine to convert a []string to []interface
// so I can pass the contents of the []string to fmt.Printf.
//
func iface(list []string) []interface{} {
  vals := make([]interface{}, len(list))
  for i, v := range list { vals[i] = v }
  return vals
}

//
//
//
func index(slice []string, value string) int {
  for i, v := range slice {
    if (v == value) {
      return i
    }
  }
  return -1
}

//
//
//
func member(list []string, a string) bool {
  for _, b := range list {
    if b == a {
      return true
    }
  }
  return false
}

//
// Give an array of string, return a list of duplicates.
//
func duplicates(child []string) []string {
  s := []string{}
  d := []string{}

  for _, c := range child {
    if member(s, c) {
      d = append(d, c)
    } else {
      s = append(s, c)
    }
  }

  return d
}

//
//
//
func swap(a []string, i1 int, i2 int) []string {
  n := make([]string, len(a))
  copy(n, a)
  n[i1], n[i2] = a[i2], a[i1]
  return n
}

