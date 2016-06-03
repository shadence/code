//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()

var/const/MAX_SAVE_SLOTS = 10

//used for alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/warnbans = 0
	var/muted = 0
	var/last_ip
	var/last_id
	var/menu_type = "general"
	var/submenu_type = "body"
	var/list/ignore_question = list()		//For roles which getting player_saves with question system

	//account data
	var/list/cid_list = list()
	var/ignore_cid_warning = 0

	//game-preferences
	var/UI_style = "White"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/ooccolor = "#b82e00"
	var/toggles = TOGGLES_DEFAULT
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_orbit = GHOST_ORBIT_CIRCLE

	//antag preferences
	var/list/be_role = list()
	var/uplinklocation = "PDA"

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/b_type = "A+"					//blood type (not-chooseable)
	var/underwear = 1					//underwear type
	var/undershirt = 1					//undershirt type
	var/backbag = 2						//backpack type
	var/h_style = "Bald"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin tone
	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = "Human"
	var/language = "None"				//Secondary language

	//Some faction information.
	var/home_system = "None"            //System of birth.
	var/citizenship = "None"            //Current home system.
	var/faction = "None"                //Antag faction/general associated faction.
	var/religion = "None"               //Religious association.
	var/nanotrasen_relation = "Neutral"

	//Mob preview
	var/icon/preview_icon = null

	//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 0

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()

	var/list/player_alt_titles = new()		// the default name of a job like "Medical Doctor"

	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/disabilities = 0

	// OOC Metadata:
	var/metadata = ""
	var/slot_name = ""

	// Whether or not to use randomized character slots
	var/randomslot = 0
	// jukebox volume
	var/volume = 100

/datum/preferences/New(client/C)
	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())
					return
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender)

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return
	update_preview_icon()
	user << browse_rsc(preview_icon, "previewicon.png")
	user << browse_rsc('html/prefs/dossier_empty.png')
	user << browse_rsc('html/prefs/dossier_photos.png')
	user << browse_rsc('html/prefs/opacity7.png')

	var/dat = "<html><body link='#045EBE' vlink='045EBE' alink='045EBE'><center>"
	dat += "<style type='text/css'><!--A{text-decoration:none}--></style>"
	dat += "<style type='text/css'>a.white, a.white:link, a.white:visited, a.white:active{color: #40628a;text-decoration: none;background: #ffffff;border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0;cursor:default;}</style>"
	dat += "<style>body{background-image:url('dossier_empty.png');background-color: #F5ECDD;background-repeat:no-repeat;background-position:center top;}</style>"
	dat += "<style>.main_menu{margin-left:150px;margin-top:135px}</style>"
	if(path)
		dat += "<div class='main_menu'>"
		dat += "Slot: <b>[real_name]</b> - "
		dat += "[menu_type=="load_slot"?"<b>Load slot</b>":"<a href=\"byond://?src=\ref[user];preference=load_slot\">Load slot</a>"] - "
		dat += "<a href=\"byond://?src=\ref[user];preference=save\">Save slot</a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=reload\">Reload slot</a><br>"
		dat += "[menu_type=="general"?"<b>General</b>":"<a href=\"byond://?src=\ref[user];preference=general\">General</a>"] - "
		dat += "[menu_type=="occupation"?"<b>Occupation</b>":"<a href=\"byond://?src=\ref[user];preference=occupation\">Occupation</a>"] - "
		dat += "[menu_type=="roles"?"<b>Roles</b>":"<a href=\"byond://?src=\ref[user];preference=roles\">Roles</a>"] - "
		dat += "[menu_type=="glob"?"<b>Global</b>":"<a href=\"byond://?src=\ref[user];preference=glob\">Global</a>"]"
		dat += "<br><a href='?src=\ref[user];preference=close\'><b><font color='#FF4444'>Close</font></b></a>"
		dat += "</div>"
	else
		dat += "Please create an account to save your preferences."

	dat += "</center><hr width='535'>"

	switch(menu_type)
		if("general")
			dat += ShowGeneral(user)
		if("occupation")
			dat += ShowOccupation(user)
		if("roles")
			dat += ShowRoles(user)
		if("glob")
			dat += ShowGlobal(user)
		if("load_slot")
			dat += ShowLoadSlot(user)

	dat += "</body></html>"
	user << browse(dat, "window=preferences;size=618x778;can_close=0;can_minimize=0;can_maximize=0;can_resize=0")

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	switch(href_list["preference"])
		if("close")
			user << browse(null, "window=preferences")
			return

		if("save")
			save_preferences()
			save_character()

		if("reload")
			load_preferences()
			load_character()

		if("changeslot")
			load_character(text2num(href_list["num"]))

		if("general")
			menu_type = "general"

		if("occupation")
			menu_type = "occupation"

		if("roles")
			menu_type = "roles"

		if("glob")
			menu_type = "glob"

		if("load_slot")
			if(!IsGuestKey(user.key))
				menu_type = "load_slot"

	switch(menu_type)
		if("general")
			process_link_general(user, href_list)

		if("occupation")
			process_link_occupation(user, href_list)

		if("roles")
			process_link_roles(user, href_list)

		if("glob")
			process_link_glob(user, href_list)

	ShowChoices(user)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1)
	if(be_random_name)
		real_name = random_name(gender)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.flavor_text = flavor_text
	character.metadata = metadata
	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.s_tone = s_tone

	character.h_style = h_style
	character.f_style = f_style

	character.home_system = home_system
	character.citizenship = citizenship
	character.personal_faction = faction
	character.religion = religion

	// Destroy/cyborgize organs

	for(var/name in organ_data)
		var/datum/organ/external/O = character.organs_by_name[name]
		var/datum/organ/internal/I = character.internal_organs_by_name[name]
		var/status = organ_data[name]

		if(status == "amputated")
			O.amputated = 1
			O.status |= ORGAN_DESTROYED
			O.destspawn = 1
		if(status == "cyborg")
			O.status |= ORGAN_ROBOT
		if(status == "assisted")
			I.mechassist()
		else if(status == "mechanical")
			I.mechanize()

		else continue


	//Disabilities
	if(disabilities & DISABILITY_NEARSIGHTED)
		character.disabilities|=NEARSIGHTED
	if(disabilities & DISABILITY_EPILEPTIC)
		character.disabilities|=EPILEPSY
	if(disabilities & DISABILITY_COUGHING)
		character.disabilities|=COUGHING
	if(disabilities & DISABILITY_TOURETTES)
		character.disabilities|=TOURETTES
	if(disabilities & DISABILITY_NERVOUS)
		character.disabilities|=NERVOUS

	// Wheelchair necessary?
	var/datum/organ/external/l_foot = character.get_organ("l_foot")
	var/datum/organ/external/r_foot = character.get_organ("r_foot")
	if((!l_foot || l_foot.status & ORGAN_DESTROYED) && (!r_foot || r_foot.status & ORGAN_DESTROYED))
		var/obj/structure/stool/bed/chair/wheelchair/W = new /obj/structure/stool/bed/chair/wheelchair (character.loc)
		character.buckled = W
		character.update_canmove()
		W.dir = character.dir
		W.buckled_mob = character
		W.add_fingerprint(character)

	if(underwear > underwear_m.len || underwear < 1)
		underwear = 0 //I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	character.underwear = underwear

	if(undershirt > undershirt_t.len || undershirt < 1)
		undershirt = 0
	character.undershirt = undershirt

	if(backbag > 4 || backbag < 1)
		backbag = 1 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

	if(icon_updates)
		character.update_body()
		character.update_hair()
