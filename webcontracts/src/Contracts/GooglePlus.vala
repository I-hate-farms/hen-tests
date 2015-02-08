
namespace WebContracts {

    public class GooglePlusSettings : Granite.Services.Settings {

        public string access_token {get; set;}
        public string current_account {get; set;}

        public GooglePlusSettings (){
            base ("org.pantheon.Contractor.google-plus");
        }

    }

    public class GooglePlus : WebContracts.Contract {

        Gtk.Label current_account_i;

        public GooglePlusSettings settings;

        const string consumer_key    = "1051606863534.apps.googleusercontent.com";
        const string consumer_secret = "cJsVzcinmC7nXjylNRcXKWsU";
        const string root_url        = "";


        public GooglePlus (){
            base ("Google Plus", "google", "google-plus",
"""[Contractor Entry]
Name=Google Plus
Icon=google
Description=Share at Google+
X-GNOME-Gettext-Domain=webcontracts
MimeType=text
Exec=%s google-plus %%u
""".printf (Utils.get_exec_path ())
);
            this.settings = new GooglePlusSettings ();
        }

        public override void build_ui () {
            base.build_ui ();

            this.current_account_i = new LLabel (this.settings.current_account);
            this.item.sensitive = false;

            var set_acc = new Gtk.Button.with_label (_("Set Account"));

            var info = new Gtk.InfoBar ();
            info.message_type = Gtk.MessageType.ERROR;
            info.add (new Gtk.Label (_("The Google+ API does not allow sharing yet!")));

            this.container.attach (new LLabel.r (_("Current Account:")), 0, 0, 1, 1);
            this.container.attach (current_account_i,                    1, 0, 1, 1);
            this.container.attach (set_acc,                              0, 1 ,2, 1);
            this.container.attach (info, 0, 2, 2, 1);

            set_acc.clicked.connect ( () => {
                var proxy = new Rest.OAuth2Proxy(consumer_key, "https://accounts.google.com/o/oauth2/auth",
                    root_url, false);

                var url = proxy.build_login_url ("http://localhost")+
                "&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile&response_type=code";
                print (url+"\n");
                var web_wind = new Gtk.Window ();
                var web_view = new WebKit.WebView ();
                web_wind.add (web_view);
                web_view.open (url);
                web_wind.show_all ();
                /*
                web_view.title_changed.connect ( () => {
                    if (web_view.uri.substring (0, 51) == "https://www.facebook.com/connect/login_success.html"){
                        this.settings.access_token = Rest.OAuth2Proxy.extract_access_token (web_view.uri);
                        web_wind.hide ();

                        var p = new Rest.OAuth2Proxy.with_token (this.consumer_key,
                            this.settings.access_token, "https://graph.facebook.com/me",
                            "https://graph.facebook.com/me", false);
                        var call = p.new_call();
                        call.add_header ("access_token", this.settings.access_token);
                        call.set_method("GET");

                        try{
                            call.run ();
                        }catch (Error e){warning (e.message);}
                        var ret = call.get_payload ();

                        var start = ret.index_of ("\"name\":\"") + 8;
                        var end   = ret.index_of ("\",", start+2);
                        this.settings.current_account = ret.substring (start, end - start);
                        this.current_account_i.label = this.settings.current_account;
                    }
                });*/
            });
        }

        public override void run (File file){
            /*string contents;
            try{
                FileUtils.get_contents (file.get_path (), out contents);
            }catch (Error e){warning (e.message);}

            var proxy = new Rest.OAuth2Proxy.with_token (consumer_key,
                this.settings.access_token, "https://api.facebook.com/method/",
                "https://api.facebook.com/method/", false);
            var call = proxy.new_call();

            call.add_header ("access_token", this.settings.access_token);
            call.add_param  ("message", contents);

            call.set_function("stream.publish");
            call.set_method("POST");

            try{
                call.run ();
            }catch (Error e){warning (e.message);}

            debug ("Payload: "+call.get_payload ());*/
            warning ("Not available yet");
        }
    }
}
