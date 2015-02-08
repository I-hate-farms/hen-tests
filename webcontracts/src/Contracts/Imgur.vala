
namespace WebContracts {

    public class Imgur : WebContracts.Contract {

        public string api_key = "9ac70d3f9e72f2bbd34c81c00fd6620b";

        public Imgur (){
            base ("Imgur", "image-x-generic", "imgur",
"""[Contractor Entry]
Name=Imgur
Icon=image-x-generic
Description=Upload to imgur.com
X-GNOME-Gettext-Domain=webcontracts
MimeType=image
Exec=%s imgur %%u
""".printf (Utils.get_exec_path ())
            );
        }

        public override void build_ui () {
            base.build_ui ();

            this.container.attach (new LLabel.r (_("No settings")), 0, 0, 1, 1);
        }

        public override void run (File file){
            string command = "curl ";
            command += "-F\"image=@"+file.get_path ()+"\" ";
            command += "-F\"key="+api_key+"\" ";
            command += "http://imgur.com/api/upload.xml";

            string ret;
            try{
                Process.spawn_command_line_sync (command, out ret);
            }catch (Error e){error (e.message);}

            var start = ret.index_of ("<original_image>");
            var end   = ret.index_of ("</original_image>");
            var link  = ret.substring (start + 16, end - (start + 16));

            try{
                Process.spawn_command_line_async ("xdg-open '"+link+"'");
            }catch (Error e){error (e.message);}
        }
    }
}
