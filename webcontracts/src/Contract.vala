
namespace WebContracts {
    
    public class Contract : GLib.Object {
        
        public Gtk.Grid     container;
        public Gtk.EventBox item;
        public Gtk.Image    icon;
        public Gtk.Switch   toggle;
        public Gtk.Label    name;
        
        public string identifier;
        public string full_name;
        public string icon_name;
        public string contract;
        
        public signal void activated (Contract container);
        
        public Contract (string name, string icon, string identifier, string contract) {
            this.contract   = contract;
            this.full_name  = name;
            this.icon_name  = icon;
            this.identifier = identifier;
        }

        public virtual void build_ui () {
            this.name   = new LLabel (full_name);
            this.icon   = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.DIALOG);
            this.item   = new Gtk.EventBox ();
            var  item_c = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
            this.toggle = new Gtk.Switch ();
            
            this.container = new Gtk.Grid ();
            this.container.margin = 12;
            this.container.row_spacing = 12;
            this.container.column_spacing = 12;
            this.container.column_homogeneous = true;
            
            item_c.pack_start (this.icon, false);
            item_c.pack_start (this.name, true);
            item_c.pack_start (this.toggle, false);
            item.add (item_c);
            item.margin_top = item.margin_bottom = 5;
            item.visible_window = false;
            
            this.toggle.valign = Gtk.Align.CENTER;
            
            this.item.button_press_event.connect ( () => {
                activated (this);
                return false;
            });
            
            this.toggle.active = File.new_for_path (Environment.get_user_data_dir () + 
                "/contractor/" + identifier + ".contract").query_exists ();
            this.toggle.notify["active"].connect ( () => {
                this.enable (toggle.active);
            });
        }
        
        public void enable (bool active) {
            var folder = File.new_for_path (Environment.get_user_data_dir () + "/contractor/");
            if (!folder.query_exists ()) {
                try {
                    folder.make_directory ();
                } catch (Error e) { warning (e.message); }
            }
            
            var file = File.new_for_path (Environment.get_user_data_dir () + 
                "/contractor/" + identifier + ".contract");
            if (active && !file.query_exists ()){
                try{
                    FileUtils.set_contents (file.get_path (), contract, -1);
                }catch (Error e){warning (e.message);}
            }else{
                if (file.query_exists ())
                    FileUtils.remove (file.get_path ());
            }
        }
        
        public virtual void run (File file){
        }
        
    }
}
