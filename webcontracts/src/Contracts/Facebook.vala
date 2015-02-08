
namespace WebContracts {

    public class FacebookSettings : Granite.Services.Settings {

        public string access_token {get; set;}
        public string current_account {get; set;}

        public FacebookSettings (){
            base ("org.pantheon.Contractor.facebook");
        }

    }

    public class Facebook : WebContracts.Contract {

        Gtk.Label current_account_i;

        public FacebookSettings settings;
        //AAACnm1B2BQ4BAAm3tUEiW9T7Al75hDgZAZBzbR7SGvlj4TG4jH00wuUUOV8k2xfL4pgpld2e1N0D5vQNrGjZCdtJKgfz8x3Ees18YL2YgZDZD
        const string consumer_key    = "184285511681294";//"234387186653456";
        const string consumer_secret = "6461289e719c125a251a85d2d615e395";//"bf379d411595a80a6637943ceb698731";
        const string root_url        = "https://www.facebook.com/";


        public Facebook (){
            base ("Facebook", "facebook", "facebook",
"""[Contractor Entry]
Name=Facebook
Icon=facebook
Description=Share at Facebook
X-GNOME-Gettext-Domain=webcontracts
MimeType=text
Exec=%s facebook %%u
"""".printf (Utils.get_exec_path ())
            );

            this.settings = new FacebookSettings ();
        }

        public override void build_ui () {
            base.build_ui ();

            this.current_account_i = new LLabel (this.settings.current_account);

            var set_acc = new Gtk.Button.with_label (_("Set Account"));
            if (this.settings.current_account == "") {
                this.container.attach (new LLabel.r (""), 0, 0, 1, 1);
            } else {
                this.container.attach (new LLabel.r (_("Current Account:")), 0, 0, 1, 1);
            }
            this.container.attach (current_account_i,                    1, 0, 1, 1);
            this.container.attach (set_acc,                              0, 1 ,2, 1);

            set_acc.clicked.connect ( () => {
                var proxy = new Rest.OAuth2Proxy(consumer_key, root_url+"dialog/oauth",
                    root_url, false);

                var url = proxy.build_login_url ("https://www.facebook.com/connect/login_success.html")+
                    "&scope=publish_stream";

                var web_wind = new Gtk.Window ();
                var web_view = new WebKit.WebView ();
                web_wind.add (web_view);
                web_view.open (url);
                web_wind.show_all ();

                web_view.title_changed.connect ( () => {
                    if (web_view.uri.substring (0, 51) == "https://www.facebook.com/connect/login_success.html"){
                        this.settings.access_token = Rest.OAuth2Proxy.extract_access_token (web_view.uri);
                        web_wind.hide ();

                        var p = new Rest.OAuth2Proxy.with_token (consumer_key,
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
                });
            });
 
        }

        public override void run (File file){
            string contents;
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

            debug ("Payload: "+call.get_payload ());
        }
    }
}
