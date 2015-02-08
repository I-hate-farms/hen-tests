
namespace WebContracts {

    public class VideobinSettings : Granite.Services.Settings {

        public string email {get; set;}

        public VideobinSettings (){
            base ("org.pantheon.Contractor.videobin");
        }
    }

    public class Videobin : WebContracts.Contract {

        public VideobinSettings settings;

        public Gtk.Entry email_i;

        public Videobin (){
            base ("Videobin", "video-x-generic", "videobin",
"""[Contractor Entry]
Name=Imagebin
Icon=video-x-generic
Description=Upload to videobin.org
X-GNOME-Gettext-Domain=webcontracts
MimeType=video
Exec=%s videobin %%u
""".printf (Utils.get_exec_path ())
            );

            this.settings = new VideobinSettings ();
        }

        public override void build_ui () {
            base.build_ui ();

            this.email_i = new Gtk.Entry () ;
            email_i.placeholder_text = _("john@smith.com");
            this.email_i.text = this.settings.email;

            this.container.attach (new LLabel.r (_("Email")), 0, 0, 1, 1);
            this.container.attach (email_i,                1, 0, 1, 1);

            this.email_i.changed.connect ( () => {
                this.settings.email = this.email_i.text;
            });
        }

        public override void run (File file){
            string url;
            string command = "curl -F\"api=1\" -F\"videoFile=@"+file.get_path ()+"\" ";
            command += "-F\"email="+email_i.text+"\" ";
            command += "-F\"title="+file.get_basename ()+"\" ";
            command += "-F\"description=none\" ";
            command += "http://videobin.org/add";

            try{
                Process.spawn_command_line_sync (command, out url);
            }catch (Error e){error (e.message);}
            try{
                Process.spawn_command_line_async ("xdg-open " + url);
            }catch (Error e){error (e.message);}
        }
    }
}
