
namespace WebContracts {

    public class PastebinSettings : Granite.Services.Settings {

        public bool   public_only {get; set;}
        public string expire      {get; set;}

        public PastebinSettings (){
            base ("org.pantheon.Contractor.pastebin");
        }
    }

    public class Pastebin : WebContracts.Contract {

        public Gtk.Switch       public_only_i;
        public Gtk.ComboBoxText expire_i;

        public PastebinSettings settings;

        public Pastebin (){
            base ("Pastebin", "text-x-generic", "pastebin",
"""[Contractor Entry]
Name=Pastebin
Icon=x-office-document
Description=Upload to pastebin.com
X-GNOME-Gettext-Domain=webcontracts
MimeType=text
Exec=%s pastebin %%u
""".printf (Utils.get_exec_path ())
            );

            this.settings = new PastebinSettings ();
        }

        public override void build_ui () {
            base.build_ui ();

            this.public_only_i = new Gtk.Switch ();
            this.expire_i      = new Gtk.ComboBoxText ();

            this.public_only_i.halign = Gtk.Align.START;
            this.public_only_i.active = this.settings.public_only;

            this.expire_i.append ("N", _("Never"));
            this.expire_i.append ("10M", _("10 minutes"));
            this.expire_i.append ("1H", _("1 hour"));
            this.expire_i.append ("1D", _("1 day"));
            this.expire_i.append ("1M", _("1 month"));
            this.expire_i.active_id = settings.expire;

            this.expire_i.changed.connect ( () => {
                this.settings.expire = this.expire_i.active_id;
            });
            this.public_only_i.notify["active"].connect ( () => {
                this.settings.public_only = this.public_only_i.active;
            });

            this.container.attach (new LLabel.r (_("Public pastes")), 0, 0, 1, 1);
            this.container.attach (public_only_i,                     1, 0, 1, 1);
            this.container.attach (new LLabel.r (_("Expire")),        0, 1, 1, 1);
            this.container.attach (expire_i,                          1, 1, 1, 1);
        }

        public override void run (File file){

string [,] FORMATS = {
{"4cs", ""},
{"6502acme", ""},
{"6502kickass", ""},
{"6502tasm", ""},
{"abap", ""},
{"actionscript", ""},
{"actionscript3", ""},
{"ada", ""},
{"algol68", ""},
{"apache", ""},
{"applescript", ""},
{"apt_sources", ""},
{"asm", ""},
{"asp", ""},
{"autoconf", ""},
{"autohotkey", ""},
{"autoit", ""},
{"avisynth", ""},
{"awk", ""},
{"bascomavr", ""},
{"bash", ""},
{"basic4gl", ""},
{"bibtex", ""},
{"blitzbasic", ""},
{"bnf", ""},
{"boo", ""},
{"bf", ""},
{"c", "c"},
{"c_mac", ""},
{"cil", ""},
{"csharp", ""},
{"cpp", "cpp"},
{"cpp-qt", ""},
{"c_loadrunner", ""},
{"caddcl", ""},
{"cadlisp", ""},
{"cfdg", ""},
{"chaiscript", ""},
{"clojure", ""},
{"klonec", ""},
{"klonecpp", ""},
{"cmake", "CMakeLists.txt"},
{"cobol", ""},
{"coffeescript", ""},
{"cfm", ""},
{"css", "css"},
{"cuesheet", ""},
{"d", "x-dsrc"},
{"dcs", ""},
{"delphi", ""},
{"oxygene", ""},
{"diff", ""},
{"div", ""},
{"dos", ""},
{"dot", ""},
{"e", ""},
{"ecmascript", ""},
{"eiffel", ""},
{"email", ""},
{"epc", ""},
{"erlang", ""},
{"fsharp", ""},
{"falcon", ""},
{"fo", ""},
{"f1", ""},
{"fortran", ""},
{"freebasic", ""},
{"freeswitch", ""},
{"gambas", ""},
{"gml", ""},
{"gdb", ""},
{"genero", ""},
{"genie", ""},
{"gettext", ""},
{"go", ""},
{"groovy", ""},
{"gwbasic", ""},
{"haskell", ""},
{"hicest", ""},
{"hq9plus", ""},
//html4strict, use html5
{"html5", "html"},
{"icon", ""},
{"idl", ""},
{"ini", "ini"},
{"inno", ""},
{"intercal", ""},
{"io", ""},
{"j", ""},
{"java", "java"},
//java5, use java
{"javascript", "js"},
//jquery, use javascript
{"kixtart", ""},
{"latex", ""},
{"lb", ""},
{"lsl2", ""},
{"lisp", ""},
{"llvm", ""},
{"locobasic", ""},
{"logtalk", ""},
{"lolcode", ""},
{"lotusformulas", ""},
{"lotusscript", ""},
{"lscript", ""},
{"lua", ""},
{"m68k", ""},
{"magiksf", ""},
{"make", "Makefile"},
{"mapbasic", ""},
{"matlab", ""},
{"mirc", ""},
{"mmix", ""},
{"modula2", ""},
{"modula3", ""},
{"68000devpac", ""},
{"mpasm", ""},
{"mxml", ""},
{"mysql", ""},
{"newlisp", ""},
//text, None
{"nsis", ""},
{"oberon2", ""},
{"objeck", ""},
{"objc", ""},
{"ocaml-brief", ""},
{"ocaml", ""},
{"pf", ""},
{"glsl", ""},
{"oobas", ""},
{"oracle11", ""},
{"oracle8", ""},
{"oz", ""},
{"pascal", ""},
{"pawn", ""},
{"pcre", ""},
{"per", ""},
{"perl", ""},
{"perl6", ""},
{"php", "php"},
{"php-brief", ""},
{"pic16", ""},
{"pike", ""},
{"pixelbender", ""},
{"plsql", ""},
{"postgresql", ""},
{"povray", ""},
{"powershell", ""},
{"powerbuilder", ""},
{"proftpd", ""},
{"progress", ""},
{"prolog", ""},
{"properties", ""},
{"providex", ""},
{"purebasic", ""},
{"pycon", ""},
{"python", "py"},
{"q", ""},
{"qbasic", ""},
{"rsplus", ""},
{"rails", ""},
{"rebol", ""},
{"reg", ""},
{"robots", ""},
{"rpmspec", ""},
{"ruby", ""},
{"gnuplot", ""},
{"sas", ""},
{"scala", ""},
{"scheme", ""},
{"scilab", ""},
{"sdlbasic", ""},
{"smalltalk", ""},
{"smarty", ""},
{"sql", ""},
{"systemverilog", ""},
{"tsql", ""},
{"tcl", ""},
{"teraterm", ""},
{"thinbasic", ""},
{"typoscript", ""},
{"unicon", ""},
{"uscript", ""},
{"vala", "vala"},
{"vbnet", ""},
{"verilog", ""},
{"vhdl", ""},
{"vim", ""},
{"visualprolog", ""},
{"vb", ""},
{"visualfoxpro", ""},
{"whitespace", ""},
{"whois", ""},
{"winbatch", ""},
{"xbasic", ""},
{"xml", "xml"},
{"xorg_conf", ""},
{"xpp", ""},
{"yaml", ""},
{"z80", ""},
{"zxbasic", ""}
};
            string code = "";
            try{
                var stream = new DataInputStream (file.read ());
                string line;
                while ((line = stream.read_line (null)) != null)
                    code += line.escape ("\t")+"\n";
            }catch (Error e){error (e.message);}

            //extension
            string tmp    = file.get_basename ();
            int i=0;
            for (i=tmp.length; i!=0;i--){
                if (tmp[i] == '.')                 break;
            }
            string extension = tmp.substring (i+1);

            //format
            string format = "text";
            for (i=0;i<FORMATS.length[0];i++){
                if (extension in FORMATS[i, 0]){
                    format = FORMATS[i, 1];
                    break;
                }
            }

            string DEVKEY = "ae76385392a5e2982025eb9427df9d49";
            string name = file.get_basename ();

            string command = "curl -F\"api_option=paste\" ";
            command += "-F\"api_user_key=\" ";
            command += "-F\"api_paste_private=0\" ";
            command += "-F\"api_paste_name="+name+"\" ";
            command += "-F\"api_paste_expire_date=10M\" ";
            command += "-F\"api_paste_format="+format+"\" ";
            command += "-F\"api_dev_key="+DEVKEY+"\" ";
            command += "-F\"api_paste_code="+code+"\" ";
            command += "http://pastebin.com/api/api_post.php";

            string url = "";
            try{
                Process.spawn_command_line_sync (command, out url);
            }catch (Error e){error (e.message);}
            try{
                Process.spawn_command_line_async ("sensible-browser "+url);
            }catch (Error e){error (e.message);}

        }
    }
}
