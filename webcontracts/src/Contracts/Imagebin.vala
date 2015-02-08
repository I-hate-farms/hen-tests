
namespace WebContracts {

    public class ImagebinSettings : Granite.Services.Settings {

        public string nickname {get; set;}

        public ImagebinSettings (){
            base ("org.pantheon.Contractor.imagebin");
        }

    }

    public class Imagebin : WebContracts.Contract {

        public ImagebinSettings settings;

        public Gtk.Entry nickname_i;

        public Imagebin (){
            base ("Imagebin", "camera-photo", "imagebin",
"""[Contractor Entry]
Name=Imagebin
Icon=camera-photo
Description=Upload to imagebin.org
X-GNOME-Gettext-Domain=webcontracts
MimeType=image
Exec="%s imagebin %%u
""".printf (Utils.get_exec_path ())
            );

            this.settings = new ImagebinSettings ();
        }

        public override void build_ui () {
            base.build_ui ();

            this.nickname_i = new Gtk.Entry ();
            this.nickname_i.text = this.settings.nickname;

            this.container.attach (new LLabel.r (_("Nickname")), 0, 0, 1, 1);
            this.container.attach (nickname_i,                1, 0, 1, 1);

            this.nickname_i.changed.connect ( () => {
                this.settings.nickname = this.nickname_i.text;
            });
        }

        public override void run (File file){
            string command = "curl ";
            command += "-F\"nickname="+this.settings.nickname+"\" ";
            command += "-F\"image=@"+file.get_path ()+";type=image/png\" ";
            command += "-F\"disclaimer_agree=Y\" -F\"Submit=Submit\" -F\"mode=add\" http://imagebin.org/index.php";

            try{
                Process.spawn_command_line_sync (command, null);
            }catch (Error e){error (e.message);}
            try{
                Process.spawn_command_line_async ("xdg-open http://imagebin.org");
            }catch (Error e){error (e.message);}
        }
    }
}
