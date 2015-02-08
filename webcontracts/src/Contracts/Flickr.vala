
namespace WebContracts {

    public class FlickrSettings : Granite.Services.Settings {

        public string token {get; set;}
        public string token_secret {get; set;}
        public string current_account {get; set;}

        public FlickrSettings (){
            base ("org.pantheon.Contractor.flickr");
        }

    }

    public class Flickr : WebContracts.Contract {

        Gtk.Label current_account_i;

        public FlickrSettings settings;

        const string consumer_key    = "707116a68c14d8b1f2938242d50b7261";
        const string consumer_secret = "1a4659bf4a2c2d44";
        const string root_url        = "http://www.flickr.com/services/";


        public Flickr (){
            base ("Flickr", "flickr", "flickr",
"""[Contractor Entry]
Name=Flickr
Icon=flickr
Description=Upload an image to flickr
X-GNOME-Gettext-Domain=webcontracts
MimeType=image
Exec=%s flickr %%u
""".printf (Utils.get_exec_path ())
            );
            this.settings = new FlickrSettings ();
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
                    acall.set_function("rest/");
                    acall.add_param ("method", "flickr.test.login");
                    acall.add_param ("api_key", consumer_key);
                    acall.set_method("GET");
                    try{
                        acall.run ();
                    }catch (Error e){warning (e.message);}
                    var response = acall.get_payload ();

                    /*parse response for account name*/
                    var start = response.index_of ("<username>");
                    var end   = response.index_of ("</username>");
                    this.settings.current_account  = response.substring (start + 10, end - (start + 10));
                    this.current_account_i.label = this.settings.current_account;
                    this.settings.token  = proxy.get_token ();
                    this.settings.token_secret = proxy.get_token_secret ();

                    this.container.remove (pin);
                    this.container.remove (btn);
                });
            });
        }

        public override void run (File file){
            uint8 [] data = null;
            try{
                FileUtils.get_data (file.get_path (), out data);
            }catch (Error e){warning (e.message);}

            var proxy = new Rest.OAuthProxy.with_token (consumer_key,
                consumer_secret, this.settings.token, this.settings.token_secret, root_url, false);
            var call = proxy.new_call();

            FileInfo info = null;
            try{
                info = file.query_info (FileAttribute.STANDARD_CONTENT_TYPE, 0);
            }catch (Error e){warning (e.message);}

            var p = new Rest.Param.new_full ("photo",
                                             0,
                                             data,
                                             info.get_content_type (),
                                             file.get_path ());

            call.add_param_full (p);

            call.set_function("upload/");
            call.set_method("POST");

            try{
                call.run ();
            }catch (Error e){warning (e.message);}
            var ret   = call.get_payload ();
            var start = ret.index_of ("<photoid>");
            var end   = ret.index_of ("</photoid>");
            var id    = ret.substring (start + 9, end - (start + 9));
            try{
                Process.spawn_command_line_sync ("xdg-open 'http://www.flickr.com/photos/upload/edit/?ids="+id+"'");
            }catch (Error e){warning (e.message);}
        }
    }
}
