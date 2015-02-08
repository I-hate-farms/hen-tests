
namespace WebContracts {

    public class TwitterSettings : Granite.Services.Settings {

        public string token {get; set;}
        public string token_secret {get; set;}
        public string current_account {get; set;}

        public TwitterSettings (){
            base ("org.pantheon.Contractor.twitter");
        }

    }

    public class Twitter : WebContracts.Contract {

        Gtk.Label current_account_i;

        public TwitterSettings settings;

        const string consumer_key    = "TPNmAVQZb2Hg5gWGw4Wg";
        const string consumer_secret = "YemkCaw6YbUb0AcqJt3uGEAYTomlKqOwFAUKCnvUpZg";
        const string root_url        = "http://twitter.com/";


        public Twitter (){
            base ("Twitter", "twitter", "twitter",
"""[Contractor Entry]
Name=Tweet
Icon=twitter
Description=Update your twitter status
X-GNOME-Gettext-Domain=webcontracts
MimeType=text
Exec=%s twitter %%u
""".printf (Utils.get_exec_path ())
            );
            this.settings = new TwitterSettings ();
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
                /*open browser for authentication*/
                var proxy = new Rest.OAuthProxy(consumer_key, consumer_secret,
                    root_url, false);
                try{
                    proxy.request_token ("oauth/request_token", "oob");
                }catch (Error e){warning (e.message);}

                var token = proxy.get_token ();
                var url   = root_url + "oauth/authorize?oauth_token=" + token;
                try {
                    GLib.Process.spawn_async(".", {"/usr/bin/xdg-open", url}, null,
                        GLib.SpawnFlags.STDOUT_TO_DEV_NULL, null, null);
                } catch(GLib.SpawnError e) {
                    warning (e.message);
                }

                /*ask for pin from browser*/
                var pin = new Gtk.Entry ();
                var btn = new Gtk.Button.with_label (_("Confirm PIN"));

                this.container.attach (pin, 0, 2, 1, 1);
                this.container.attach (btn, 1, 2, 1, 1);
                this.container.show_all ();

                btn.clicked.connect ( () => {
                    try{
                        proxy.access_token  ("oauth/access_token", pin.text);
                    }catch (Error e){warning (e.message);}
                    var acall = proxy.new_call ();
                    acall.set_function("account/verify_credentials.xml");
                    acall.set_method("GET");
                    try{
                        acall.run ();
                    }catch (Error e){warning (e.message);}
                    var response = acall.get_payload ();

                    /*parse response for account name*/
                    var start = response.index_of ("<screen_name>");
                    var end   = response.index_of ("</screen_name>");
                    this.settings.current_account  = response.substring (start + 13, end - (start + 13));
                    this.current_account_i.label = this.settings.current_account;

                    this.settings.token  = proxy.get_token ();
                    this.settings.token_secret = proxy.get_token_secret ();

                    this.container.remove (pin);
                    this.container.remove (btn);
                });
            });
        }

        public override void run (File file){
            string status_text;
            try{
                FileUtils.get_contents (file.get_path (), out status_text);
            }catch (Error e){warning (e.message);}
            print ("New Status: "+status_text+"\n");
            var proxy = new Rest.OAuthProxy.with_token (consumer_key,
                consumer_secret, this.settings.token, this.settings.token_secret, root_url, false);
            var call = proxy.new_call();
            call.add_param("status", status_text);

            call.set_function("statuses/update.xml");
            call.set_method("POST");

            try{
                call.run ();
            }catch (Error e){warning (e.message);}
        }
    }
}
