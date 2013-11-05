/******************************************************************************\
 * Corpus - Kayboard Assesment API
 * (c) 2013 Tab Computing
 *     All Rights Reserved
\******************************************************************************/

package corpus

//
// Settings
//
type Settings struct {
  Debug bool      // Debug mode.
  Numbered bool   // Layouts are numbered if the top row is always numbers 1-9.
  Symmetric bool  // When evolving, apply the symmetric score.
}

//
// Customize settings.
//
func Setup(custom_settings Settings) {
  settings = custom_settings
}

//
// Default settings.
//
var settings Settings = Settings{true, true, true};

