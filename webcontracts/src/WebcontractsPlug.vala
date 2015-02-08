
namespace Translations {
    const string name = N_("Sharing Accounts");
    const string facebook = N_("Share at Facebook");
    const string flickr = N_("Upload an image to flickr");
    const string googleplus = N_("Share at Google+");
    const string google_search = N_("Search Google");
    const string google_search_desc = N_("Search on the Web with google");
    const string google_trans = N_("Google Translate");
    const string google_trans_desc = N_("Translate text with Google translator");
    const string imagebin = N_("Upload to imagebin.org");
    const string imgur = N_("Upload to imgur.com");
    const string pastebin = N_("Upload to pastebin.com");
    const string twitter = N_("Tweet");
    const string twitter_desc = N_("Update your twitter status");
    const string videobin = N_("Upload to videobin.org");
    const string wikipedia = N_("Wikipedia");
    const string wikipedia_desc = N_("Look up on wikipedia");
    const string youtube = N_("Upload a video to youtube");

}


public class SharingAccountsPlug : Switchboard.Plug {
    public static SharingAccountsPlug plug;

    WebContracts.Contract current;

    public SharingAccountsPlug (){
        Object (category: Category.SYSTEM,
                code_name: "switchboard-plub-webcontracts",
                display_name: _("Web Contracts"),
                description: _("Manage various contracts for web services"),
                icon: "system-users");
        message (Build.PLUG_CATEGORY) ;
        plug = this;
    }

    public override Gtk.Widget get_widget () {
        var box  = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        //var main_grid = new Gtk.Grid ();

        var list = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        var view = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        var scrl = new Gtk.ScrolledWindow (null, null);

        scrl.add_with_viewport (list);
        scrl.width_request = 300;
        list.margin = 12;

        box.pack_start (scrl, false);
        box.pack_start (view);
        //main_grid.attach (scrl, 0, 0, 1, 1);
        //main_grid.attach (view, 0, 1, 1, 1);

        var cur_box   = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
        var cur_label = new Gtk.Label (_("Select a service"));
        var cur_image = new Gtk.Image.from_icon_name (
            "preferences-desktop-online-accounts", Gtk.IconSize.DIALOG);
        cur_image.pixel_size = 64;

        var attrs = new Pango.AttrList ();
        attrs.insert (new Pango.AttrFontDesc (
            Pango.FontDescription.from_string ("bold 25")));
        cur_label.set_attributes (attrs);

        cur_label.halign = Gtk.Align.START;
        cur_box.pack_start (cur_image, false);
        cur_box.pack_start (cur_label);

        view.pack_start (cur_box, false);
        view.margin = 30;

        foreach (var contract in Utils.get_contracts ()) {
            contract.activated.connect ((c) => {
                if (this.current != null) {
                    this.current.item.get_style_context ().remove_class (Gtk.STYLE_CLASS_BUTTON);
                    view.remove (this.current.container);
                }
                this.current = c;
                c.item.get_style_context ().add_class (Gtk.STYLE_CLASS_BUTTON);
                c.item.get_style_context ().set_state (Gtk.StateFlags.ACTIVE);
                c.item.get_style_context ().invalidate ();
                view.add (c.container);
                view.show_all ();
                cur_label.label = c.name.label;
                cur_image.icon_name = c.icon.icon_name;
            });

            contract.build_ui ();
            list.pack_start (contract.item, false);
        }

        //main_grid.show_all ();
        //return main_grid;
        box.show_all() ;
        return box ;
    }

    public override void shown () {
    }

    public override void hidden () {
    }

    public override void search_callback (string location) {
    }

    // 'search' returns results like ("Keyboard → Behavior → Duration", "keyboard<sep>behavior")
    public override async Gee.TreeMap<string, string> search (string search) {
        return new Gee.TreeMap<string, string> (null, null);
    }
}


public Switchboard.Plug get_plug (Module module) {
    message ("Activating Wb Contracts plug");
    var plug = new SharingAccountsPlug ();
    return plug;
}

