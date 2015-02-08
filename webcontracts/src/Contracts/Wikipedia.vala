
namespace WebContracts {

    public class Wikipedia : WebContracts.Contract {

        public Wikipedia (){
            base (_("Wikipedia"), "accessories-dictionary", "wikipedia",
"""[Contractor Entry]
Name=Wikipedia
Icon=accessories-dictionary
Description=Look up on wikipedia
X-GNOME-Gettext-Domain=webcontracts
MimeType=text
Exec=%s wikipedia %%u
""".printf (Utils.get_exec_path ())
            );
        }

        public override void build_ui () {
            base.build_ui ();

            this.container.attach (new LLabel.r (_("No settings")), 0, 0, 1, 1);
        }

        public override void run (File file){

            string content;
            try{
                FileUtils.get_contents (file.get_path (), out content);
            }catch (Error e){warning (e.message);}

            var command = "xdg-open 'http://www.wikipedia.org/wiki/"+content+"'";

            string ret;
            try{
                Process.spawn_command_line_sync (command, out ret);
            }catch (Error e){error (e.message);}
        }
    }
}
