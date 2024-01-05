#define WHITELISTFILE "data/whitelist.txt"

var/global/list/Six_whitelist = file2list("config/whitelist/Six_whitelist.txt")

/hook/startup/proc/loadSixwhitelist()
	if(config.Six_whitelist)
		load_Six_whitelist()
	return 1

/proc/load_Six_whitelist()
	var/text = file2list("config/whitelist/Six_whitelist.txt")
	if(!text)
		log_misc("Failed to load config/Six_whitelist.txt")
	else
		Six_whitelist = splittext(text, "\n")
/proc/check_Six_whitelist(mob/M)
	if(!Six_whitelist)
		return 0
	return ("[M.ckey]" in Six_whitelist)

var/global/list/Five_whitelist = file2list("config/whitelist/Five_whitelist.txt")

/hook/startup/proc/loadFivewhitelist()
	if(config.Five_whitelist)
		load_Five_whitelist()
	return 1

/proc/load_Five_whitelist()
	var/text = file2list("config/whitelist/Five_whitelist.txt")
	if(!text)
		log_misc("Failed to load config/Five_whitelist.txt")
	else
		Five_whitelist = splittext(text, "\n")
/proc/check_Five_whitelist(mob/M)
	if(!Five_whitelist)
		return 0
	return ("[M.ckey]" in Five_whitelist)

var/global/list/Four_whitelist = file2list("config/whitelist/Four_whitelist.txt")

/hook/startup/proc/loadFourwhitelist()
	if(config.Four_whitelist)
		load_Four_whitelist()
	return 1

/proc/load_Four_whitelist()
	var/text = file2list("config/whitelist/Four_whitelist.txt")
	if(!text)
		log_misc("Failed to load config/Four_whitelist.txt")
	else
		Four_whitelist = splittext(text, "\n")
/proc/check_Four_whitelist(mob/M)
	if(!Four_whitelist)
		return 0
	return ("[M.ckey]" in Four_whitelist)

var/global/list/Three_whitelist = file2list("config/whitelist/Three_whitelist.txt")

/hook/startup/proc/loadThreewhitelist()
	if(config.Three_whitelist)
		load_Three_whitelist()
	return 1

/proc/load_Three_whitelist()
	var/text = file2list("config/whitelist/Three_whitelist.txt")
	if(!text)
		log_misc("Failed to load config/Three_whitelist.txt")
	else
		Three_whitelist = splittext(text, "\n")
/proc/check_Three_whitelist(mob/M)
	if(!Three_whitelist)
		return 0
	return ("[M.ckey]" in Three_whitelist)

var/global/list/Second_whitelist = file2list("config/whitelist/Second_whitelist.txt")

/hook/startup/proc/loadSecondwhitelist()
	if(config.Second_whitelist)
		load_Second_whitelist()
	return 1

/proc/load_Second_whitelist()
	var/text = file2list("config/whitelist/Second_whitelist.txt")
	if(!text)
		log_misc("Failed to load config/Second_whitelist.txt")
	else
		Three_whitelist = splittext(text, "\n")
/proc/check_Second_whitelist(mob/M)
	if(!Second_whitelist)
		return 0
	return ("[M.ckey]" in Second_whitelist)

var/global/list/Frist_whitelist = file2list("config/whitelist/Frist_whitelist.txt")

/hook/startup/proc/loadFristwhitelist()
	if(config.Frist_whitelist)
		load_Frist_whitelist()
	return 1

/proc/load_Frist_whitelist()
	var/text = file2list("config/whitelist/Frist_whitelist.txt")
	if(!text)
		log_misc("Failed to load config/Frist_whitelist.txt")
	else
		Frist_whitelist = splittext(text, "\n")
/proc/check_Frist_whitelist(mob/M)
	if(!Frist_whitelist)
		return 0
	return ("[M.ckey]" in Frist_whitelist)

var/global/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		if(config.usealienwhitelistSQL)
			if(!load_alienwhitelistSQL())
				to_world_log("Could not load alienwhitelist via SQL")
		else
			load_alienwhitelist()
	return 1
/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
		return 0
	else
		alien_whitelist = splittext(text, "\n")
		return 1
/proc/load_alienwhitelistSQL()
	var/DBQuery/query = dbcon_old.NewQuery("SELECT * FROM whitelist")
	if(!query.Execute())
		to_world_log(dbcon_old.ErrorMsg())
		return 0
	else
		while(query.NextRow())
			var/list/row = query.GetRowData()
			if(alien_whitelist[row["ckey"]])
				var/list/A = alien_whitelist[row["ckey"]]
				A.Add(row["race"])
			else
				alien_whitelist[row["ckey"]] = list(row["race"])
	return 1

/proc/is_species_whitelisted(mob/M, species_name)
	var/datum/species/S = all_species[species_name]
	return is_alien_whitelisted(M, S)

//todo: admin aliens
/proc/is_alien_whitelisted(mob/M, species)
	if(!M || !species)
		return 0
	if (GLOB.skip_allow_lists)
		return TRUE
	if(!config.usealienwhitelist)
		return 1
	if(check_rights(R_ADMIN, 0, M))
		return 1

	if(istype(species,/datum/language))
		var/datum/language/L = species
		if(!(L.flags & (WHITELISTED|RESTRICTED)))
			return 1
		return whitelist_lookup(L.name, M.ckey)

	if(istype(species,/datum/species))
		var/datum/species/S = species
		if(!(S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_IS_RESTRICTED)))
			return 1
		return whitelist_lookup(S.get_bodytype(S), M.ckey)

	return 0

/proc/whitelist_lookup(item, ckey)
	if(!alien_whitelist)
		return 0

	if(config.usealienwhitelistSQL)
		//SQL Whitelist
		if(!(ckey in alien_whitelist))
			return 0;
		var/list/whitelisted = alien_whitelist[ckey]
		if(lowertext(item) in whitelisted)
			return 1
	else
		//Config File Whitelist
		for(var/s in alien_whitelist)
			if(findtext(s,"[ckey] - [item]"))
				return 1
			if(findtext(s,"[ckey] - All"))
				return 1
	return 0

#undef WHITELISTFILE
