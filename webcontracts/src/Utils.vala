class LLabel : Gtk.Label {
    public LLabel (string label) {
        this.set_halign (Gtk.Align.START);
        this.label = label;
    }
    public LLabel.indent (string label) {
        this (label);
        this.margin_left = 10;
    }
    public LLabel.markup (string label){
        this (label);
        this.use_markup = true;
    }
    public LLabel.r (string label){
        this.set_halign (Gtk.Align.END);
        this.label = label;
    }
    public LLabel.right_with_markup (string label){
        this.set_halign (Gtk.Align.END);
        this.use_markup = true;
        this.label = label;
    }
}

namespace Utils
{
    Gee.List<WebContracts.Contract>? contracts = null;

    public Gee.List<WebContracts.Contract> get_contracts ()
    {
        if (contracts != null)
            return contracts;

        contracts = new Gee.ArrayList<WebContracts.Contract> ();

       // if (Constants.TWITTER == "true")
            contracts.add (new WebContracts.Twitter ());
       // if (Constants.IMAGEBIN == "true")
            contracts.add (new WebContracts.Imagebin ());
       // if (Constants.PASTEBIN == "true")
            contracts.add (new WebContracts.Pastebin ());
       // if (Constants.VIDEOBIN == "true")
            contracts.add (new WebContracts.Videobin ());
       // if (Constants.GOOGLE_TRANSLATE == "true")
            contracts.add (new WebContracts.GoogleTranslate ());
       // if (Constants.FLICKR == "true")
            contracts.add (new WebContracts.Flickr ());
       // if (Constants.IMGUR == "true")
            contracts.add (new WebContracts.Imgur ());
       // if (Constants.FACEBOOK == "true")
            contracts.add (new WebContracts.Facebook ());
       // if (Constants.GOOGLE_PLUS == "true")
            contracts.add (new WebContracts.GooglePlus ());
       // if (Constants.YOUTUBE == "true")
            contracts.add (new WebContracts.Youtube ());
       // if (Constants.WIKIPEDIA == "true")
            contracts.add (new WebContracts.Wikipedia ());
       // if (Constants.GOOGLE_SEARCH == "true")
            contracts.add (new WebContracts.GoogleSearch ());

        return contracts;
    }

    public string get_exec_path ()
    {
// #if HAVE_NEW_SWITCHBOARD
            return "webcontracts";
/* #else
            return Build.PKGDATADIR + "/webcontracts";
#endif */
    }
}
