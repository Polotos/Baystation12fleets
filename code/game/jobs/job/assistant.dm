/datum/job/assistant
	title = "Assistant"
	department_flag = null
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	economic_power = 1
	access = list()
	outfit_type = /singleton/hierarchy/outfit/job/assistant

/datum/job/assistant/get_access()
	return list()
