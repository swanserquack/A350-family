####    A350XWB electrical system    ####
####    Derived from A380-Omega Electrical system by Narendran Muraleedharan (c) 2014
####    Andrea Vezzali    ####


# TODO: Apu


# Main Electrical Loop

var electrical = {
       init : func {
            me.UPDATE_INTERVAL = 1;
            me.loopid = 0;
            
			# Create Suppliers - name, type, volts, amps, dep, dep_prop, dep_max, dep_req, sw_prop

			suppliers = [supplier.new("GEN1A", "AC", 230, 435, 1, "/engines/engine/n2", 100, 5, "/controls/electric/contact/GEN1A"),
				supplier.new("GEN1B", "AC", 230, 435, 1, "/engines/engine/n2", 100, 5, "/controls/electric/contact/GEN1B"),
				supplier.new("GEN2A", "AC", 230, 435, 1, "/engines/engine[1]/n2", 100, 5, "/controls/electric/contact/GEN2A"),
				supplier.new("GEN2B", "AC", 230, 435, 1, "/engines/engine[1]/n2", 100, 5, "/controls/electric/contact/GEN2B"),
				supplier.new("ATU1A", "AC", 115, 250, 1, "/engines/engine/n2", 100, 5, "/controls/electric/contact/ATU1A"),
				supplier.new("ATU1B", "AC", 115, 250, 1, "/engines/engine/n2", 100, 5, "/controls/electric/contact/ATU1B"),
				supplier.new("ATU2A", "AC", 115, 250, 1, "/engines/engine[1]/n2", 100, 5, "/controls/electric/contact/ATU2A"),
				supplier.new("ATU2B", "AC", 115, 250, 1, "/engines/engine[1]/n2", 100, 5, "/controls/electric/contact/ATU2B"),
				#supplier.new("TR1", "DC", 29, 16, 1, "/controls/electric/elec-buses/AC230_1A/volts", 230, 220, ""),
				supplier.new("TR1", "DC", 29, 16, 1, "/engines/engine/n2", 100, 5, "/controls/electric/contact/TR1"),
				supplier.new("TR2", "DC", 29, 16, 1, "/engines/engine[1]/n2", 100, 5, "/controls/electric/contact/TR2"),
				supplier.new("TR_EMER_1", "DC", 29, 16, 1, "/engines/engine/n2", 100, 5, "/controls/electric/contact/TR_EMER_1"),
				supplier.new("TR_EMER_2", "DC", 29, 16, 1, "/engines/engine[1]/n2", 100, 5, "/controls/electric/contact/TR_EMER_2"),
				supplier.new("BAT1", "DC", 29, 16, 0, "", 0, 0, "/controls/electric/contact/BAT1"),
				supplier.new("BAT2", "DC", 29, 16, 0, "", 0, 0, "/controls/electric/contact/BAT2"),
				supplier.new("BAT_EMER_1", "DC", 29, 16, 0, "", 0, 0, "/controls/electric/contact/BAT_EMER_1"),
				supplier.new("BAT_EMER_2", "DC", 29, 16, 0, "", 0, 0, "/controls/electric/contact/BAT_EMER_2"),
				supplier.new("EXT1", "AC", 115, 782, 1, "/controls/electric/ground/EXT1", 1, 1, "/controls/electric/contact/EXT1"),
				supplier.new("EXT2", "AC", 115, 782, 1, "/controls/electric/ground/EXT2", 1, 1, "/controls/electric/contact/EXT2"),
				supplier.new("APU", "AC", 230, 652, 1, "/engines/engine[2]/n2", 100, 5, "/controls/electric/contact/APU"),
				supplier.new("RAT", "AC", 230, 217, 1, "/velocities/airspeed-kt", 300, 140, "/controls/electric/contact/emer/RAT"),
				supplier.new("ATU_EMER_1", "AC", 115, 60, 1, "/velocities/airspeed-kt", 300, 140, "/controls/electric/contact/emer/RAT"),
				supplier.new("ATU_EMER_2", "AC", 115, 60, 1, "/velocities/airspeed-kt", 300, 140, "/controls/electric/contact/emer/RAT"),
				supplier.new("STAT_INV_1", "AC", 115, 60, 0, "", 0, 0, "/controls/electric/contact/BAT1"),
				supplier.new("STAT_INV_2", "AC", 115, 60, 0, "", 0, 0, "/controls/electric/contact/BAT2")];
			
			# Suppliers in a bus must supply similar voltages
			buses = [bus.new("AC_230_1A", "AC", ["GEN1A", "APU"]),
				bus.new("AC_230_1B", "AC", ["GEN1B", "EMER_230_AC1", "APU"]),
				bus.new("AC_230_2A", "AC", ["GEN2A", "APU"]),
				bus.new("AC_230_2B", "AC", ["GEN2B", "EMER_230_AC2", "APU"]),
				bus.new("AC_115_1A", "AC", ["ATU1A", "EXT1"]),
				bus.new("AC_115_1B", "AC", ["ATU1B"]),
				bus.new("AC_115_2A", "AC", ["ATU2A", "EXT2"]),
				bus.new("AC_115_2B", "AC", ["ATU2B"]),
				bus.new("EMER_230_AC1", "AC", ["RAT"]),
				bus.new("EMER_230_AC2", "AC", ["RAT"]),
				bus.new("EMER_115_AC1", "AC", ["ATU_EMER_1", "STAT_INV_1"]),
				bus.new("EMER_115_AC2", "AC", ["ATU_EMER_2", "STAT_INV_2"]),
				bus.new("DC1", "DC", ["BAT1", "TR1"]),
				bus.new("DC2", "DC", ["BAT1", "TR2"]),
				bus.new("EMER_DC1", "DC", ["BAT_EMER_1", "TR_EMER_1"]),
				bus.new("EMER_DC2", "DC", ["BAT_EMER_2", "TR_EMER_2"])];
								
			# Outputs
			outputs = [output.new("avionics", 12, 4, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]), 
				output.new("comm0", 12, 8, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]),
				output.new("efis", 18, 8, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]),
				output.new("comm1", 12, 8, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]),
				output.new("anti-icing", 24, 2, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]), 
				output.new("ext-lts", 24, 12, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]), 
				output.new("nav0", 16, 8, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]),
				output.new("nav1", 16, 8, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]),
				output.new("adf", 12, 6, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]),
				output.new("dme", 12, 6, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"]),
				output.new("eng-starter", 110, 20, ["AC_115_1A", "AC_115_1B", "AC_115_2A", "AC_115_2B"]),
				output.new("integ-lts", 12, 1, ["DC1", "DC2", "EMER_DC1", "EMER_DC2"])];

			# Busties
			busties = [bustie.new("AC230_BUS_TIE", ["AC230_BUS_TIE_1A","AC230_BUS_TIE_1B","AC230_BUS_TIE_2A","AC230_BUS_TIE_2B"], ""),
				bustie.new("AC230_BUS_TIE_1A", ["AC_230_1A"], "/controls/electric/contact/AC230_BUS_TIE_1A"),
				bustie.new("AC230_BUS_TIE_1B", ["AC_230_1B"], "/controls/electric/contact/AC230_BUS_TIE_1B"),
				bustie.new("AC230_BUS_TIE_2A", ["AC_230_2A"], "/controls/electric/contact/AC230_BUS_TIE_2A"),
				bustie.new("AC230_BUS_TIE_2B", ["AC_230_2B"], "/controls/electric/contact/AC230_BUS_TIE_2B"),
				bustie.new("AC115_BUS_TIE", ["AC115_BUS_TIE_1A","AC115_BUS_TIE_1B","AC115_BUS_TIE_2A","AC115_BUS_TIE_2B"], ""),
				bustie.new("AC115_BUS_TIE_1A", ["AC_115_1A"], "/controls/electric/contact/AC115_BUS_TIE_1A"),
				bustie.new("AC115_BUS_TIE_1B", ["AC_115_1B"], "/controls/electric/contact/AC115_BUS_TIE_1B"),
				bustie.new("AC115_BUS_TIE_2A", ["AC_115_2A"], "/controls/electric/contact/AC115_BUS_TIE_2A"),
				bustie.new("AC115_BUS_TIE_2B", ["AC_115_2B"], "/controls/electric/contact/AC115_BUS_TIE_2B"),
				bustie.new("DC_BUS_TIE1", ["DC1", "EMER_DC1"], "/controls/electric/contact/DC_BUS_TIE1"),
				bustie.new("DC_BUS_TIE2", ["EMER_DC1","EMER_DC2"], "/controls/electric/contact/DC_BUS_TIE2"),
				bustie.new("DC_BUS_TIE3", ["EMER_DC2","DC2"], "/controls/electric/contact/DC_BUS_TIE3")];
            
            setprop("/systems/electric/util-volts", 0);
            setprop("/controls/elec_panel/dc-btc", 0);
            setprop("/controls/elec_panel/ac-btc", 0);
            me.reset();
    },
    	update : func {
    	
    	# Tie Objects to Properties
    	
    	foreach(var supply; suppliers) {
    	
    		var amps = supply.supply();
    		var volts = 0;
    		
    		if (amps != 0) {
    		
    			volts = supply.volts;
    		
    		}
    		
    		setprop("/systems/electric/suppliers/" ~ supply.name ~ "/volts", volts);
    		setprop("/systems/electric/suppliers/" ~ supply.name ~ "/amps", amps);
    	
    	}
    	
    	foreach(var bus; buses) {
    	
    		setprop("/systems/electric/elec-buses/" ~ bus.name ~ "/volts", bus.get_volts());
    		setprop("/systems/electric/elec-buses/" ~ bus.name ~ "/amps", bus.get_amps());
    		setprop("/systems/electric/elec-buses/" ~ bus.name ~ "/watts", bus.get_amps()*bus.get_volts()); # P = V*i
    	
    	}

    	foreach(var output; outputs) {
    	
    		output.serviceable();
    	
    	}
    	
    	foreach(var bustie; busties) {
    	
    		bustie.tie();
    	
    	}
    	
    	# Communication and Navigation Systems
    	
    	if (getprop("/systems/electric/outputs/comm0") == 1) {
    	
    		setprop("/instrumentation/comm/serviceable", 1);
    	
    	} else {
    	
    		setprop("/instrumentation/comm/serviceable", 0);
    	
    	}
    	
    	if (getprop("/systems/electric/outputs/comm1") == 1) {
    	
    		setprop("/instrumentation/comm[1]/serviceable", 1);
    	
    	} else {
    	
    		setprop("/instrumentation/comm[1]/serviceable", 0);
    	
    	}
    	
    	if (getprop("/systems/electric/outputs/nav0") == 1) {
    	
    		setprop("/instrumentation/nav/serviceable", 1);
    	
    	} else {
    	
    		setprop("/instrumentation/nav/serviceable", 0);
    	
    	}
    	
    	if (getprop("/systems/electric/outputs/nav1") == 1) {
    	
    		setprop("/instrumentation/nav[1]/serviceable", 1);
    	
    	} else {
    	
    		setprop("/instrumentation/nav[1]/serviceable", 0);
    	
    	}
    	
    	# External Power Availablility
    	# FIXME - NEEDS TO BE MOVED TO GROUND SERVICE LATER
    	var gspeed = getprop("/velocities/groundspeed-kt");
    	for(var i=1; i<=2; i=i+1) {
    		if(gspeed < 1) {
    			setprop("/controls/electric/ground/EXT"~i, 1);
    		} else {
    			setprop("/controls/electric/ground/EXT"~i, 0);
    			setprop("/controls/electric/contact/EXT"~i, 0);
    		}
    	}
    	
    	# The rest of the individual pump/equipment serviceability is managed in the individual system files.

	},

        reset : func {
            me.loopid += 1;
            me._loop_(me.loopid);
    },
        _loop_ : func(id) {
            id == me.loopid or return;
            me.update();
            settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
    }

};

setlistener("sim/signals/fdm-initialized", func
 {
 electrical.init();
 print("A350XWB Electrical System Initialized");
 },0, 0);
