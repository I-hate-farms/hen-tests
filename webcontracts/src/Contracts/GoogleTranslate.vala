
namespace WebContracts {

    public class GoogleTranslateSettings : Granite.Services.Settings {

        public string default_language {get; set;}

        public GoogleTranslateSettings (){
            base ("org.pantheon.Contractor.google-translate");
        }

    }

    public class GoogleTranslate : WebContracts.Contract {

        public GoogleTranslateSettings settings;

        public Gtk.ComboBoxText default_language_i;

        public GoogleTranslate (){
            base (_("Google Translate"), "preferences-desktop-locale", "google-translate",
"""[Contractor Entry]
Name=Google Translate
Icon=preferences-desktop-locale
Description=Translate text with Google translator
X-GNOME-Gettext-Domain=webcontracts
MimeType=text
Exec=%s google-translate %%u
""".printf (Utils.get_exec_path ())
            );

            this.settings = new GoogleTranslateSettings ();
        }

        public override void build_ui () {
            base.build_ui ();

            this.default_language_i = new Gtk.ComboBoxText ();
            this.default_language_i.append ("af", _("Afrikaans"));
            this.default_language_i.append ("sq", _("Albanian"));
            this.default_language_i.append ("ar", _("Arabic"));
            this.default_language_i.append ("hy", _("Armenian"));
            this.default_language_i.append ("az", _("Azerbaijani"));
            this.default_language_i.append ("eu", _("Basque"));
            this.default_language_i.append ("be", _("Belarusian"));
            this.default_language_i.append ("bn", _("Bengali"));
            this.default_language_i.append ("bg", _("Bulgarian"));
            this.default_language_i.append ("ca", _("Catalan"));
            this.default_language_i.append ("zh-CN", _("Chinese (Simplified)"));
            this.default_language_i.append ("zh-TW", _("Chinese (Traditional)"));
            this.default_language_i.append ("hr", _("Croation"));
            this.default_language_i.append ("cs", _("Czech"));
            this.default_language_i.append ("da", _("Danish"));
            this.default_language_i.append ("nl", _("Dutch"));
            this.default_language_i.append ("en", _("English"));
            this.default_language_i.append ("et", _("Estonian"));
            this.default_language_i.append ("tl", _("Filipino"));
            this.default_language_i.append ("fi", _("Finnish"));
            this.default_language_i.append ("fr", _("French"));
            this.default_language_i.append ("gl", _("Galician"));
            this.default_language_i.append ("ka", _("Georgian"));
            this.default_language_i.append ("de", _("German"));
            this.default_language_i.append ("el", _("Greek"));
            this.default_language_i.append ("gu", _("Gujarati"));
            this.default_language_i.append ("ht", _("Haitian Creole"));
            this.default_language_i.append ("iw", _("Hebrew"));
            this.default_language_i.append ("hi", _("Hindi"));
            this.default_language_i.append ("hu", _("Hungarian"));
            this.default_language_i.append ("is", _("Icelandic"));
            this.default_language_i.append ("id", _("Indonesian"));
            this.default_language_i.append ("ga", _("Irish"));
            this.default_language_i.append ("it", _("Italian"));
            this.default_language_i.append ("ja", _("Japanese"));
            this.default_language_i.append ("kn", _("Kannada"));
            this.default_language_i.append ("ko", _("Korean"));
            this.default_language_i.append ("la", _("Latin"));
            this.default_language_i.append ("lv", _("Latvian"));
            this.default_language_i.append ("lt", _("Lithuanian"));
            this.default_language_i.append ("mk", _("Macedonian"));
            this.default_language_i.append ("ms", _("Malay"));
            this.default_language_i.append ("mt", _("Maltese"));
            this.default_language_i.append ("no", _("Norwegian"));
            this.default_language_i.append ("fa", _("Persian"));
            this.default_language_i.append ("pl", _("Polish"));
            this.default_language_i.append ("pt", _("Portuguese"));
            this.default_language_i.append ("ro", _("Romanian"));
            this.default_language_i.append ("ru", _("Russian"));
            this.default_language_i.append ("sr", _("Serbian"));
            this.default_language_i.append ("sk", _("Slovak"));
            this.default_language_i.append ("sl", _("Slovenian"));
            this.default_language_i.append ("es", _("Spanish"));
            this.default_language_i.append ("sw", _("Swahili"));
            this.default_language_i.append ("sv", _("Swedish"));
            this.default_language_i.append ("ta", _("Tamil"));
            this.default_language_i.append ("te", _("Telugu"));
            this.default_language_i.append ("th", _("Thai"));
            this.default_language_i.append ("tr", _("Turkish"));
            this.default_language_i.append ("uk", _("Ukrainian"));
            this.default_language_i.append ("ur", _("Urdu"));
            this.default_language_i.append ("vi", _("Vitnamese"));
            this.default_language_i.append ("cy", _("Welsh"));
            this.default_language_i.append ("yi", _("Yiddish"));

            if (this.settings.default_language == "") {
                foreach (string lang in GLib.Intl.get_language_names ()) {
                    this.default_language_i.active_id = lang;
                    if (this.default_language_i.get_active () != -1) {
                        this.settings.default_language = lang;
                        break;
                    }
                }
            } else {
                this.default_language_i.active_id = this.settings.default_language;
            }

            // if there is no recognised languages, fallback to english
            if (this.default_language_i.get_active () == -1) {
                this.settings.default_language = "en";
            }

            this.container.attach (new LLabel.r (_("Default language")), 0, 0, 1, 1);
            this.container.attach (default_language_i,                1, 0, 1, 1);

            this.default_language_i.changed.connect ( () => {
                this.settings.default_language = this.default_language_i.active_id;
            });
        }

        public override void run (File file){
            string content;
            try{
                FileUtils.get_contents (file.get_path (), out content);
            }catch (Error e){warning (e.message);}
            try{
                Process.spawn_command_line_async ("xdg-open 'http://www.translate.google.com/#auto|"+this.settings.default_language+"|"+content+"'");
            }catch (Error e){warning (e.message);}
        }
    }
}
