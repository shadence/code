/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 50
	var/max_internal_charge = 15000 		// Two charged borgs in a row with default cell
	var/current_internal_charge = 15000 	// Starts charged, to prevent power surges on round start
	var/charging_cap_active = 25000			// Active Cap - When cyborg is inside
	var/charging_cap_passive = 2500			// Passive Cap - Recharging internal capacitor when no cyborg is inside
	var/icon_update_tick = 0				// Used to update icon only once every 10 ticks
	var/construct_op = 0
	var/circuitboard = "/obj/item/weapon/circuitboard/cyborgrecharger"
	var/locked = 1
	var/open = 1
	req_access = list(access_robotics)
	var/recharge_speed
	var/repairs


/obj/machinery/recharge_station/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/cyborgrecharger(null)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/cell/high(null)
	RefreshParts()
	build_icon()
	update_icon()

/obj/machinery/recharge_station/RefreshParts()
	recharge_speed = 0
	repairs = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		recharge_speed += C.rating * 100
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		repairs += M.rating - 1
	for(var/obj/item/weapon/stock_parts/cell/C in component_parts)
		recharge_speed *= C.maxcharge / 10000

/obj/machinery/recharge_station/process()
	if(stat & (BROKEN))
		return
	if((stat & (NOPOWER)) && !current_internal_charge) // No Power.
		return

	var/chargemode = 0
	if(src.occupant)
		process_occupant()
		chargemode = 1
	// Power Stuff

	if(stat & NOPOWER)
		current_internal_charge = max(0, (current_internal_charge - (50 * CELLRATE))) // Internal Circuitry, 50W load. No power - Runs from internal cell
		return // No external power = No charging

	if(max_internal_charge < current_internal_charge)
		current_internal_charge = max_internal_charge// Safety check if varedit adminbus or something screws up
	// Calculating amount of power to draw
	var/charge_diff = max_internal_charge - current_internal_charge // OK we have charge differences
	charge_diff = charge_diff / CELLRATE 							// Deconvert from Charge to Joules
	if(chargemode)													// Decide if use passive or active power
		charge_diff = between(0, charge_diff, charging_cap_active)	// Trim the values to limits
	else															// We should have load for this tick in Watts
		charge_diff = between(0, charge_diff, charging_cap_passive)

	charge_diff += 50 // 50W for circuitry

	if(idle_power_usage != charge_diff) // Force update, but only when our power usage changed this tick.
		idle_power_usage = charge_diff
		update_use_power(1,1)

	current_internal_charge = min((current_internal_charge + ((charge_diff - 50) * CELLRATE)), max_internal_charge)

	if(icon_update_tick >= 10)
		update_icon()
		icon_update_tick = 0
	else
		icon_update_tick++

	return 1


/obj/machinery/recharge_station/allow_drop()
	return 0

/obj/machinery/recharge_station/examine()
	usr << "The charge meter reads: [round(chargepercentage())]%"

/obj/machinery/recharge_station/proc/chargepercentage()
	return ((current_internal_charge / max_internal_charge) * 100)

/obj/machinery/recharge_station/relaymove(mob/user as mob)
	if(user.stat)
		return
	open_machine()

/obj/machinery/recharge_station/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(occupant)
		occupant.emp_act(severity)
	open_machine()
	..(severity)

/obj/machinery/recharge_station/attack_paw(user as mob)
	return attack_hand(user)

/obj/machinery/recharge_station/attack_ai(user as mob)
	return attack_hand(user)

/obj/machinery/recharge_station/attackby(obj/item/P as obj, mob/user as mob)
	if(open)
		if(default_deconstruction_screwdriver(user, "borgdecon2", "borgcharger0", P))
			return

	if(exchange_parts(user, P))
		return

	default_deconstruction_crowbar(P)

/obj/machinery/recharge_station/attack_hand(mob/user)
	if(..())	return
	if(construct_op == 0)
		toggle_open()
	else
		user << "The recharger can't be closed in this state."
	add_fingerprint(user)

/obj/machinery/recharge_station/proc/toggle_open()
	if(open)
		close_machine()
	else
		open_machine()

/obj/machinery/recharge_station/open_machine()
	if(occupant)
		if (occupant.client)
			occupant.client.eye = occupant
			occupant.client.perspective = MOB_PERSPECTIVE
		occupant.forceMove(loc)
		occupant = null
		use_power = 1
	open = 1
	density = 0
	build_icon()

/obj/machinery/recharge_station/close_machine()
	if(!panel_open)
		for(var/mob/living/silicon/robot/R in loc)
			R.stop_pulling()
			if(R.client)
				R.client.eye = src
				R.client.perspective = EYE_PERSPECTIVE
			R.forceMove(src)
			occupant = R
			use_power = 2
			add_fingerprint(R)
			break
		open = 0
		density = 1
		build_icon()

/obj/machinery/recharge_station/update_icon()
	..()
	overlays.Cut()
	switch(round(chargepercentage()))
		if(1 to 20)
			overlays += image('icons/obj/objects.dmi', "statn_c0")
		if(21 to 40)
			overlays += image('icons/obj/objects.dmi', "statn_c20")
		if(41 to 60)
			overlays += image('icons/obj/objects.dmi', "statn_c40")
		if(61 to 80)
			overlays += image('icons/obj/objects.dmi', "statn_c60")
		if(81 to 98)
			overlays += image('icons/obj/objects.dmi', "statn_c80")
		if(99 to 110)
			overlays += image('icons/obj/objects.dmi', "statn_c100")

/obj/machinery/recharge_station/proc/build_icon()
	if(NOPOWER|BROKEN)
		if(open)
			icon_state = "borgcharger0"
		else
			if(occupant)
				icon_state = "borgcharger1"
			else
				icon_state = "borgcharger2"
	else
		icon_state = "borgcharger0"

/obj/machinery/recharge_station/proc/process_occupant()
	if(src.occupant)
		if (istype(occupant, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = occupant
			if(R.module)
				R.module.respawn_consumable(R)
			if(repairs)
				R.heal_organ_damage(repairs, repairs - 1)
			if(!R.cell)
				return
			else if(R.cell.charge >= R.cell.maxcharge)
				var/diff = min(R.cell.maxcharge - R.cell.charge, 250) 	// Capped at 250 charge / tick
				diff = min(diff, current_internal_charge) 				// No over-discharging
				R.cell.give(diff)
				current_internal_charge -= diff
				return
			else
				R.cell.charge = min(R.cell.charge + recharge_speed, R.cell.maxcharge)
				return
