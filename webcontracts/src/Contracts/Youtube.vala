
namespace WebContracts {

    public class YoutubeSettings : Granite.Services.Settings {

        public string access_token {get; set;}
        public string current_account {get; set;}

        public YoutubeSettings (){
            base ("org.pantheon.Contractor.youtube");
        }
    }

    public class Youtube : WebContracts.Contract {

        Gtk.Label current_account_i;

        public YoutubeSettings settings;

        const string consumer_key    = "1051606863534.apps.googleusercontent.com";
        const string consumer_secret = "cJsVzcinmC7nXjylNRcXKWsU";
        const string developer_key   = "AI39si5VgENAGjsbu3aEu1adSzZH6303ZJ-KINUwfKGPz6RHosiX0zyaQIcwxUPFYMyGI6W9VQWzFlYdG-I9XAu5DvbmtTnySw";


        public Youtube (){
            base ("Youtube", "totem", "youtube",
"""[Contractor Entry]
Name=Youtube
Icon=totem
Description=Upload a video to youtube
MimeType=video
X-GNOME-Gettext-Domain=webcontracts
Exec=%s youtube %%u
""".printf (Utils.get_exec_path ())
            );
            this.settings = new YoutubeSettings ();
        }

        public override void build_ui () {
            base.build_ui ();

            this.current_account_i = new LLabel (this.settings.current_account);
            this.item.sensitive = false;

            var set_acc = new Gtk.Button.with_label (_("Set Account"));

            this.container.attach (new LLabel.r (_("Current Account:")), 0, 0, 1, 1);
            this.container.attach (current_account_i,                    1, 0, 1, 1);
            this.container.attach (set_acc,                              0, 1 ,2, 1);

            set_acc.clicked.connect ( () => {
                var proxy = new Rest.OAuth2Proxy(consumer_key, "https://accounts.google.com/o/oauth2/auth",
                    "https://accounts.google.com/o/oauth2/auth", false);

                var url = proxy.build_login_url ("http://localhost")+
                    "&scope=https://gdata.youtube.com&response_type=code";
                var web_wind = new Gtk.Window ();
                var web_view = new WebKit.WebView ();
                web_wind.add (web_view);
                web_view.open (url);
                web_wind.set_default_size (640, 480);
                web_wind.show_all ();

                web_view.resource_request_starting.connect ( (frame, res, req) => {
                    if (req.uri.substring (0, 16) == "http://localhost"){
                        print ("\n%s\n%s\n", req.uri, req.uri.substring (23));
                        var code  = req.uri.substring (23);
                        web_wind.destroy ();

                        var uri = "https://accounts.google.com/o/oauth2/token";
                        var msg = Soup.Form.request_new ("POST", uri,
                            "code", code,
                            "client_id", consumer_key,
                            "client_secret", consumer_secret,
                            "grant_type", "authorization_code",
                            "redirect_uri", "http://localhost");

                        var session = new Soup.Session ();
                        session.send_message (msg);
                        var resp = (string)msg.response_body.data;

                        var parser = new Json.Parser ();
                        try{
                            parser.load_from_data (resp);
                        }catch (Error e){warning (e.message);}
                        this.settings.access_token = parser.get_root ().
                            get_object ().get_string_member ("access_token");
                    }
                });
            });
        }

        public override void run (File file){
            uint8 [] data = null;
            try{
                FileUtils.get_data (file.get_path (), out data);
            }catch (Error e){warning (e.message);}
            FileInfo info = null;
            try{
                info = file.query_info (FileAttribute.STANDARD_CONTENT_TYPE, 0);
            }catch (Error e){warning (e.message);}

            var multipart_boundary = "f93dcbA3";
            var description =
"""<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom"
  xmlns:media="http://search.yahoo.com/mrss/"
  xmlns:yt="http://gdata.youtube.com/schemas/2007">

  <media:group>
    <media:title type='plain'>Testvid</media:title>
    <media:description type="plain">
      A test video.
    </media:description>
    <media:category
      scheme="http://gdata.youtube.com/schemas/2007/categories.cat">People
    </media:category>
    <media:keywords>test, video</media:keywords>
  </media:group>
</entry>
""";
            /*build the request*/
            string request_header = "";

            var boundary_line = "--"+multipart_boundary;
            request_header += boundary_line;
            request_header += "Content-Type: application/atom+xml; charset=UTF-8\n\n";
            request_header += description;

            request_header += boundary_line;
            request_header += "Content-Type: "+info.get_content_type ()+"\n";
            request_header += "Content-Transfer-Encoding: binary\n\n";
            uint8 [] final_request = request_header.data;
            int req_size = final_request.length;
            final_request.resize (req_size + data.length);
            int idx = 0;
            for (var i=req_size;i<final_request.length;i++){
                final_request [i] = data [idx];
            }
            string end = "\n";
            end += boundary_line;
            /**/

            var session = new Soup.Session ();
            var msg     = new Soup.Message ("POST",
                "http://uploads.gdata.youtube.com/feeds/api/users/default/uploads");

            msg.set_request ("multipart/related; boundary=\"f93dcbA3\"", Soup.MemoryUse.STATIC, final_request);

            msg.request_headers.append ("AuthSub", "token=\""+this.settings.access_token+"\"");
            msg.request_headers.append ("GData-Version", "2");
            msg.request_headers.append ("X-GData-Key", "key=" + developer_key);
            msg.request_headers.append ("Slug", file.get_path ());
            msg.request_headers.append ("Content-type",
                         "multipart/related; boundary=\""+multipart_boundary+"\"");
            msg.request_headers.append ("Connection", "close");

            int progress = final_request.length;
            print ("Data to write: %i\n", progress);
            msg.wrote_body_data.connect ( (chunk) => {
                progress -= (int)chunk.length;
                print ("Wrote %i, %i to go!\n", (int)chunk.length, progress);
                if (progress == 0){
                    print ("\nBody:\n"+((string)msg.response_body.data)+"\n");
                    print ("\nHeader Length: %f\n", msg.response_headers.get_content_length ());
                }
            });

            session.send_message (msg);
            msg.finished.connect ( () => {
                print ("\nBody:\n"+((string)msg.response_body.data)+"\n");
                print ("\nHeader Length: %f\n", msg.response_headers.get_content_length ());
            });

            /*var start = ret.index_of ("<photoid>");
            var end   = ret.index_of ("</photoid>");
            var id    = ret.substring (start + 9, end - (start + 9));
            try{
                Process.spawn_command_line_sync ("xdg-open 'http://www.flickr.com/photos/upload/edit/?ids="+id+"'");
            }catch (Error e){warning (e.message);}*/
        }
    }
}
