
namespace WebContracts {

    public class GoogleSearch : WebContracts.Contract {

        public GoogleSearch () {
            base (_("Google Search"), "google", "google-search",
"""
[Contractor Entry]
Name=Search Google
Icon=google
Description=Search on the Web with google
X-GNOME-Gettext-Domain=webcontracts
MimeType=text
Exec=%s google-search %%u
"""".printf (Utils.get_exec_path ())
            );
        }

        public override void build_ui () {
            base.build_ui ();

            this.container.attach (new LLabel.r (_("No settings")), 0, 0, 1, 1);
        }

        public override void run (File file) {

            string content;
            try {
                FileUtils.get_contents (file.get_path (), out content);
            } catch (Error e){warning (e.message);}

            var command = "xdg-open 'http://www.google.com/#q="+content+"'";

            string ret;
            try{
                Process.spawn_command_line_sync (command, out ret);
            } catch (Error e){ error (e.message); }
        }
    }
}
