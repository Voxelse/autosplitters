//Made by Coltaho 6/24/2018

state("snes9x-x64")
{
	byte bosshp : 0x5C80A8, 0xE8F; //enemy health (first slot in a section used for all enemies)
	byte secondarybosshp : 0x5C80A8, 0xECF; //used for sigma 3 and eagle
	byte enemyid : 0x5C80A8, 0xE72; //enemy object id
	byte enemyidtwo : 0x5C80A8, 0xEB2; //enemy object id 2
	byte myhp : 0x5C80A8, 0xBCF; //current health
	byte mylives : 0x5C80A8, 0x1F80; //current lives
	byte titleselection : 0x5C80A8, 0x3C; //what cursor is on during title screen
	byte currentlevel : 0x5C80A8, 0x1F7A; //current stage
	byte fade : 0x5C80A8, 0xB3; //current amount of screen fade
	byte mycontroller : 0x5C80A8, 0xA8; //controller input
	byte myvisits : 0x5C80A8, 0x1F7E; //visits to hadoukun, turns to 133 when you get it
	byte myhearts : 0x5C80A8, 0x1F9C; //Bitflags for heart tanks collected. Format hgfedcba 
	//a = Penguin b = Armadillo c = Eagle d = Chameleon e = Mammoth f = Kuwanger g = Mandrill h = Octopus	
}


state("snes9x")
{
	byte bosshp : 0x3832C4, 0xE8F;
	byte secondarybosshp : 0x3832C4, 0xECF;
	byte enemyid : 0x3832C4, 0xE72;
	byte enemyidtwo : 0x3832C4, 0xEB2;
	byte myhp : 0x3832C4, 0xBCF;
	byte mylives : 0x3832C4, 0x1F80;
	byte titleselection : 0x3832C4, 0x3C;
	byte currentlevel : 0x3832C4, 0x1F7A;
	byte fade : 0x3832C4, 0xB3;
	byte mycontroller : 0x3832C4, 0xA8;
	byte myvisits : 0x3832C4, 0x1F7E;
	byte myhearts : 0x3832C4, 0x1F9C;
}

init
{
	print("--Setting init variables!--");
	vars.bosses = new Dictionary<string, int>();
	vars.bosses["introboss"] = 50;
	vars.bosses["introafterboss"] = 60;
	vars.bosses["penguin"] = 2;
	vars.bosses["eagle"] = 82;
	vars.bosses["octopus"] = 7;
	vars.bosses["mammmoth"] = 12;
	vars.bosses["kuwanger"] = 5;
	vars.bosses["armadilllo"] = 20;
	vars.bosses["mandrill"] = 49;
	vars.bosses["chameleon"] = 10;
	vars.bosses["sigma1"] = 99;
	vars.bosses["sigma2"] = 93;
	vars.bosses["sigma3"] = 97;
	vars.bosses["sigmafinal"] = 101;
	vars.inBossFight = 0;
	vars.sigmaFight = 1;
	vars.started = 0;
	vars.iknowimdead = 0;
	vars.introdone = 0;
}

start { 
	if (vars.started == 1) {
		print("--Starting, Reset vars!--");
		vars.inBossFight = 0;
		vars.sigmaFight = 1;
		vars.started = 0;
		vars.iknowimdead = 0;
		vars.introdone = 0;
	}
	if (current.fade == 15 && (current.currentlevel == 35 || current.currentlevel == 3) && old.mycontroller == 0 && current.mycontroller == 16 && current.titleselection == 0 && current.myhp == 30) {
		print("--Here we go!--");
		return true;
	}
}

update {
	print("--combat: " + vars.inBossFight + " Current EnemyID: " + current.enemyid + " --bosshp: " + current.bosshp + " --myhp: " + current.myhp);
}

split
{
	//split after intro (Zero stops yapping and screen fades to black)
	if (vars.introdone == 0 && current.currentlevel == 0) {
		if (current.enemyid == vars.bosses["introafterboss"] || current.enemyidtwo == vars.bosses["introafterboss"]) {
			vars.inBossFight = 1;
		}
		if (vars.inBossFight == 1 && current.fade == 0) {
			vars.inBossFight = 0;
			vars.introdone = 1;
			print("--Yay intro done!--");
			return true;
		}
	}
	
	//split when chill penguin tank is picked up
	if (settings["chillpenguin"] && ((old.myhearts & (1 << 0)) == 0) && ((current.myhearts & (1 << 0)) != 0)) {
		print("--Yay chill penguin heart got!--");
		return true;
	}
	
	//split when we get hadouken
	if (settings["hadouken"] && old.myvisits < 133 && current.myvisits == 133) {
		print("--Yay HADOUKEN!--");
		return true;
	}
	
	//logic for figuring out if we died during a boss fight
	if (current.myhp == 0 && current.bosshp != 0 && vars.inBossFight == 1 && vars.iknowimdead == 0) {
		vars.inBossFight = 0;
		vars.iknowimdead = 1;
		print("--You died!--");
		if (vars.sigmaFight == 2) {
			vars.sigmaFight = 1;
			print("--You Died during Sigma Phase 2 Man!--");
		}
		if (current.mylives == 1) {
			vars.sigmaFight = 1;
			print("--You Gameovered Man!--");
		}
	} else if (current.mylives < old.mylives && vars.inBossFight == 1) {
		vars.inBossFight = 0;
		vars.iknowimdead = 1;
		print("--You died to falling?!--");
	} else if (current.myhp > 0 && vars.iknowimdead == 1) {
		vars.iknowimdead = 0;
		print("--You have risen!--");
	}
	
	//split on each maverick kill when in first stages, and sigma 1 and 2 last boss kills
	if (current.currentlevel != 0 && (current.currentlevel <= 8 || current.enemyid == vars.bosses["sigma1"] || current.enemyid == vars.bosses["sigma2"])) {
		if (vars.inBossFight == 0) {
			if (current.bosshp == 28 && old.bosshp == 27) {
				print("--Starting boss!--");
				vars.inBossFight = 1;				
			}
		} else {
			if (current.bosshp == 0) {
				vars.inBossFight = 0;
				print("--Yay boss dead!--");
				return true;
			}
		}
	} 
	
	//special split on sigma 3 and eagle since they are dumb and use a different enemy object location
	if (current.enemyidtwo == vars.bosses["sigma3"] || (current.enemyidtwo == vars.bosses["eagle"] && current.currentlevel == 5)) {
		if (vars.inBossFight == 0) {
			if ((current.secondarybosshp == 32 && old.secondarybosshp == 0) || (current.secondarybosshp == 32 && old.secondarybosshp == 31)) {
				print("--Starting Sigma 3 or Eagle!--");
				vars.inBossFight = 1;				
			}
		} else {
			if (current.secondarybosshp == 0) {
				vars.inBossFight = 0;
				print("--Yay Sigma 3 or Eagle boss dead!--");
				return true;
			}
		}
	} 
	
	//split on final boss hit when in phase 2
	if (current.enemyid == vars.bosses["sigmafinal"]) {
		if (vars.inBossFight == 0) {
			if (current.bosshp == 28 && old.bosshp == 27) {
				print("--Starting final sigma phase " + (vars.sigmaFight) + "!--");
				vars.inBossFight = 1;
			}
		} else {
			if (current.bosshp == 0) {
				vars.inBossFight = 0;
				print("--Yay sigma phase " + (vars.sigmaFight) + " dead!--");
				vars.sigmaFight++;				
			}
		}
		if (vars.sigmaFight == 3) {
			print("--Yay Final Sigma boss dead! You Win!--");
			return true;
		}
	}
	return;
}

startup
{
	refreshRate = 60;
	settings.Add("hundosplits", true, "Optional 100% splits");
	settings.SetToolTip("hundosplits", "Turn off if you don't want to split on these events");
	settings.Add("chillpenguin", true, "- Chill Penguin Split", "hundosplits");
	settings.Add("hadouken", true, "- Hadouken Split", "hundosplits");
	
	settings.Add("main", false, "Mega Man X AutoSplitter v1.0 by Coltaho");
	settings.Add("main0", false, "- Website : https://github.com/Coltaho/Autosplitters", "main");
	settings.Add("main1", false, "- Supported emulators : Snes9X 1.56+ 32 and 64 bit", "main");
	settings.Add("main2", false, "- Splits on boss kill, get used to it", "main");
	settings.SetToolTip("main", "Pretty cool, right?");
}