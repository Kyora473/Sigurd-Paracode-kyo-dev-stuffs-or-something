// Point controlling procs

/mob/camera/blob/proc/can_buy(var/cost = 15)
	if(blob_points < cost)
		src << "<span class='warning'>You cannot afford this.</span>"
		return 0
	blob_points -= cost
	return 1

/mob/camera/blob/proc/add_points(var/points = 0)
	if(points)
		blob_points = min(max_blob_points, blob_points + points)

// Power verbs

/mob/camera/blob/verb/transport_core()
	set category = "Blob"
	set name = "Jump to Core"
	set desc = "Transport back to your core."

	if(blob_core)
		src.loc = blob_core.loc

/mob/camera/blob/verb/jump_to_node()
	set category = "Blob"
	set name = "Jump to Node"
	set desc = "Transport back to a selected node."

	if(blob_nodes.len)
		var/list/nodes = list()
		for(var/i = 1; i <= blob_nodes.len; i++)
			nodes["Blob Node #[i]"] = blob_nodes[i]
		var/node_name = input(src, "Choose a node to jump to.", "Node Jump") in nodes
		var/obj/effect/blob/node/chosen_node = nodes[node_name]
		if(chosen_node)
			src.loc = chosen_node.loc

/mob/camera/blob/verb/create_shield()
	set category = "Blob"
	set name = "Create Shield Blob (10)"
	set desc = "Create a shield blob."


	var/turf/T = get_turf(src)

	if(!T)
		return

	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)

	if(!B)//We are on a blob
		src << "There is no blob here!"
		return

	if(!istype(B, /obj/effect/blob/normal))
		src << "Unable to use this blob, find a normal one."
		return

	if(!can_buy(10))
		return


	B.change_to(/obj/effect/blob/shield)
	return


/mob/camera/blob/verb/create_resource()
	set category = "Blob"
	set name = "Create Resource Blob (40)"
	set desc = "Create a resource tower which will generate points for you."


	var/turf/T = get_turf(src)

	if(!T)
		return

	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)

	if(!B)//We are on a blob
		src << "There is no blob here!"
		return

	if(!istype(B, /obj/effect/blob/normal))
		src << "Unable to use this blob, find a normal one."
		return

	for(var/obj/effect/blob/resource/blob in orange(4))
		src << "There is a resource blob nearby, move more than 4 tiles away from it!"
		return

	if(!can_buy(40))
		return


	B.change_to(/obj/effect/blob/resource)
	var/obj/effect/blob/resource/R = locate() in T
	if(R)
		R.overmind = src

	return

/mob/camera/blob/proc/create_core()
	set category = "Blob"
	set name = "Create Core Blob (100)"
	set desc = "Create another Core Blob to aid in the station takeover"


	var/turf/T = get_turf(src)

	if(!T)
		return

	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)

	if(!B)//We are on a blob
		src << "There is no blob here!"
		return

	if(!istype(B, /obj/effect/blob/normal))
		src << "Unable to use this blob, find a normal one."
		return

	for(var/obj/effect/blob/core/blob in orange(15))
		src << "There is another core blob nearby, move more than 15 tiles away from it!"
		return

	if(!can_buy(100))
		return


	B.change_to(/obj/effect/blob/core, src)

	return

/mob/camera/blob/verb/create_node()
	set category = "Blob"
	set name = "Create Node Blob (60)"
	set desc = "Create a Node."


	var/turf/T = get_turf(src)

	if(!T)
		return

	var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)

	if(!B)//We are on a blob
		src << "There is no blob here!"
		return

	if(!istype(B, /obj/effect/blob/normal))
		src << "Unable to use this blob, find a normal one."
		return

	for(var/obj/effect/blob/node/blob in orange(5))
		src << "There is another node nearby, move more than 5 tiles away from it!"
		return

	if(!can_buy(60))
		return


	B.change_to(/obj/effect/blob/node)
	return


/mob/camera/blob/verb/create_factory()
	set category = "Blob"
	set name = "Create Factory Blob (60)"
	set desc = "Create a Spore producing blob."


	var/turf/T = get_turf(src)

	if(!T)
		return

	var/obj/effect/blob/B = locate(/obj/effect/blob) in T
	if(!B)
		src << "You must be on a blob!"
		return

	if(!istype(B, /obj/effect/blob/normal))
		src << "Unable to use this blob, find a normal one."
		return

	for(var/obj/effect/blob/factory/blob in orange(7))
		src << "There is a factory blob nearby, move more than 7 tiles away from it!"
		return

	if(!can_buy(60))
		return

	B.change_to(/obj/effect/blob/factory)
	return


/mob/camera/blob/verb/revert()
	set category = "Blob"
	set name = "Remove Blob"
	set desc = "Removes a blob."

	var/turf/T = get_turf(src)
	if(!T)
		return

	var/obj/effect/blob/B = locate(/obj/effect/blob) in T
	if(!B)
		src << "You must be on a blob!"
		return

	if(istype(B, /obj/effect/blob/core))
		src << "Unable to remove this blob."
		return

	B.Delete()
	return


/mob/camera/blob/verb/spawn_blob()
	set category = "Blob"
	set name = "Expand Blob (5)"
	set desc = "Attempts to create a new blob in this tile. If the tile isn't clear we will attack it, which might clear it."

	var/turf/T = get_turf(src)

	if(!T)
		return

	var/obj/effect/blob/B = locate() in T
	if(B)
		src << "There is a blob here!"
		return

	var/obj/effect/blob/OB = locate() in circlerange(src, 1)
	if(!OB)
		src << "There is no blob adjacent to you."
		return

	for (var/mob/living/M in T.contents)
		if(M && !(M.stat))
			src << "You can't expand to a tile containing a living entity."
			return

	if(!can_buy(5))
		return
	OB.expand(T, 0)
	return

/mob/camera/blob/proc/click_create_shield(obj/effect/blob/B)
	if(!B)//We are on a blob
		src << "There is no blob here!"
		return

	if(!istype(B, /obj/effect/blob/normal))
		src << "Unable to use this blob, find a normal one."
		return

	if(!can_buy(10))
		return


	B.change_to(/obj/effect/blob/shield)
	return

/mob/camera/blob/proc/click_expand_blob(var/turf/T)

	if(!T)
		return

	var/obj/effect/blob/B = locate() in T
	if(B)
		src << "There is a blob here!"
		return

	var/obj/effect/blob/OB = locate() in circlerange(T, 1)
	if(!OB)
		src << "There is no blob adjacent to that tile."
		return

	if(!can_buy(5))
		return
	OB.expand(T, 0)
	return

/mob/camera/blob/verb/rally_spores()
	set category = "Blob"
	set name = "Rally Spores (5)"
	set desc = "Rally the spores to move to your location."

	if(!can_buy(5))
		return

	var/list/surrounding_turfs = block(locate(x - 1, y - 1, z), locate(x + 1, y + 1, z))
	if(!surrounding_turfs.len)
		return

	for(var/mob/living/simple_animal/hostile/blobspore/BS in living_mob_list)
		if(isturf(BS.loc) && get_dist(BS, src) <= 20)
			BS.LoseTarget()
			BS.Goto(pick(surrounding_turfs), BS.move_to_delay)
	return