/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = "/obj/item/projectile/bullet/revbullet"

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = "/obj/item/projectile/bullet"

/obj/item/ammo_casing/a418
	desc = "A .418 bullet casing."
	caliber = "357"
	projectile_type = "/obj/item/projectile/bullet/suffocationbullet"

/obj/item/ammo_casing/a666
	desc = "A .666 bullet casing."
	caliber = "357"
	projectile_type = "/obj/item/projectile/bullet/cyanideround"

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = "/obj/item/projectile/bullet/weakbullet"

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = "/obj/item/projectile/bullet/midbullet2"

/obj/item/ammo_casing/c9mmr
	desc = "A 9mm rubber bullet casing."
	caliber = "9mm"
	projectile_type = "/obj/item/projectile/bullet/weakbullet/rubber"

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = "/obj/item/projectile/bullet/midbullet"

/obj/item/ammo_casing/c45r
	desc = "A .45 rubber bullet casing."
	caliber = ".45"
	projectile_type = "/obj/item/projectile/bullet/weakbullet/rubber"

/obj/item/ammo_casing/a12mm
	desc = "A 12mm bullet casing."
	caliber = "12mm"
	projectile_type = "/obj/item/projectile/bullet/midbullet2"

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "blshell"
	caliber = "shotgun"
	projectile_type = "/obj/item/projectile/bullet"
	m_amt = 12500

/obj/item/ammo_casing/shotgun/buckshot
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet
	pellets = 5
	variance = 0.8

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A weak beanbag shell."
	icon_state = "bshell"
	projectile_type = "/obj/item/projectile/bullet/weakbullet/beanbag"
	m_amt = 500

/obj/item/ammo_casing/shotgun/stunslug
	name = "stun shell"
	desc = "An electrified, stunning taser slug for shotguns."
	icon_state = "stunshell"
	projectile_type = "/obj/item/projectile/bullet/stunslug"
	m_amt = 2500

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary shell"
	desc = "An incendiary slug."
	icon_state = "ishell"
	projectile_type = /obj/item/projectile/bullet/incendiary
	m_amt = 2500

/obj/item/ammo_casing/shotgun/dart
	name = "shotgun darts"
	desc = "A dart for use in shotguns."
	icon_state = "dart"
	projectile_type = "/obj/item/projectile/energy/dart"
	m_amt = 12500

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = "/obj/item/projectile/bullet/a762"

/obj/item/ammo_casing/a145
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/heavy/a145

/obj/item/ammo_casing/r4046
	name = "A 40x46mm grenade"
	desc = "A 40x46mm grenade (rubber)."
	icon_state = "40x46"
	caliber = "40x46"
	projectile_type = /obj/item/projectile/bullet/grenade/r4046

/obj/item/ammo_casing/caseless
	desc = "A caseless bullet casing."

/obj/item/ammo_casing/caseless/fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params, var/distro, var/quiet)
	if (..())
		loc = null
		return 1
	else
		return 0

/obj/item/ammo_casing/caseless/a75
	desc = "A .75 bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/caseless/rocket
	name = "HE rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon = 'tauceti/items/weapons/syndicate/syndicate_guns.dmi'
	icon_state = "rocket-he"
	projectile_type = "/obj/item/projectile/missile"
	caliber = "rocket"

/obj/item/ammo_casing/caseless/rocket/emp
	name = "EMP rocket shell"
	desc = "A EMP rocket designed to be fired from a launcher."
	icon_state = "rocket-emp"
	icon = 'tauceti/items/weapons/syndicate/syndicate_guns.dmi'
	projectile_type = "/obj/item/projectile/missile/emp"
	caliber = "rocket"

/obj/item/ammo_casing/chameleon
	name = "chameleon bullets"
	desc = "A set of bullets for the Chameleon Gun."
	projectile_type = "/obj/item/projectile/bullet/chameleon"
	caliber = ".45"

//=================NEW PROJECTILE HOLDERS=================\\
/obj/item/ammo_casing/l10
	caliber = "energy"
	projectile_type = "/obj/item/projectile/l10"
