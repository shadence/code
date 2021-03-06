/obj/item/weapon/gun/projectile
	desc = "Now comes in flavors like GUN. Uses 10mm ammo, for some reason."
	name = "projectile gun"
	icon_state = "pistol"
	origin_tech = "combat=2;materials=2"
	w_class = 3.0
	m_amt = 1000
	fire_delay = 0
	recoil = 1
	var/mag_type = /obj/item/ammo_box/magazine/m9mm //Removes the need for max_ammo and caliber info
	var/obj/item/ammo_box/magazine/magazine
	var/energy_gun = 0 //Used in examine, if 1 - no ammo count.

/obj/item/weapon/gun/projectile/New()
	..()
	magazine = new mag_type(src)
	chamber_round()
	update_icon()
	return

/obj/item/weapon/gun/projectile/process_chamber(var/eject_casing = 1, var/empty_chamber = 1, var/no_casing = 0)
//	if(chambered)
//		return 1
	if(crit_fail && prob(50))  // IT JAMMED GODDAMIT
		last_fired += pick(20,40,60)
		return
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(isnull(AC) || !istype(AC))
		chamber_round()
		return
	if(eject_casing)
		AC.loc = get_turf(src) //Eject casing onto ground.
		AC.SpinAnimation(10, 1) //next gen special effects
		spawn(3) //next gen sound effects
			playsound(src.loc, 'sound/weapons/shell_drop.ogg', 50, 1)
	if(empty_chamber)
		chambered = null
	if(no_casing)
		qdel(AC)
	chamber_round()
	return

/obj/item/weapon/gun/projectile/proc/chamber_round()
	if (chambered || !magazine)
		return
	else if (magazine.ammo_count())
		chambered = magazine.get_round()
		chambered.loc = src
		if(chambered.BB)
			if(chambered.reagents && chambered.BB.reagents)
				var/datum/reagents/casting_reagents = chambered.reagents
				casting_reagents.trans_to(chambered.BB, casting_reagents.total_volume) //For chemical darts/bullets
				casting_reagents.delete()
	return

/obj/item/weapon/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	if (istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			user.remove_from_mob(AM)
			magazine = AM
			magazine.loc = src
			user << "<span class='notice'>You load a new magazine into \the [src].</span>"
			chamber_round()
			A.update_icon()
			update_icon()
			return 1
		else if (magazine)
			user << "<span class='notice'>There's already a magazine in \the [src].</span>"
	return 0

/obj/item/weapon/gun/projectile/can_fire()
	if(chambered && chambered.BB)
		return 1

/obj/item/weapon/gun/projectile/attack_self(mob/living/user as mob)
	if (magazine)
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine.update_icon()
		magazine = null
		user << "<span class='notice'>You pull the magazine out of \the [src]!</span>"
	else
		user << "<span class='notice'>There's no magazine in \the [src].</span>"
	update_icon()
	return

/obj/item/weapon/gun/projectile/Destroy()
	qdel(magazine)
	magazine = null
	..()
/obj/item/weapon/gun/projectile/examine()
	..()
	if(!energy_gun)
		usr << "Has [get_ammo()] round\s remaining."
	return

/obj/item/weapon/gun/projectile/proc/get_ammo(var/countchambered = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets