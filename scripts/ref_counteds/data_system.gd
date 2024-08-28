class_name DataSystem extends RefCounted


const DEFAULT_PATH: String = "user://data.cfg"
const LOCAL_PATH: String = "./data.cfg"

static var data_path: String = DEFAULT_PATH


static func check_local_data() -> void:
	var cfg := ConfigFile.new()
	
	var err := cfg.load(LOCAL_PATH)
	if err != OK:
		return
	
	data_path = LOCAL_PATH


static func get_data_dir() -> String:
	if data_path == DEFAULT_PATH:
		return OS.get_user_data_dir()
	else:
		return "."


static func load_texture(path: String) -> Texture:
	var file := FileAccess.open(path, FileAccess.READ)
	
	assert(file, "cannot open the file: %s" % path)
	if not file:
		return null
	
	var bytes := file.get_buffer(file.get_length())
	var img := Image.new()
	
	var err := FAILED
	if path.ends_with(".png") or path.ends_with(".PNG"):
		err = img.load_png_from_buffer(bytes)
	elif path.ends_with(".jpg") or path.ends_with(".jpeg") or path.ends_with(".JPG") or path.ends_with(".JPEG"):
		err = img.load_jpg_from_buffer(bytes)
	
	assert(err == OK, "cannot open the file: %s" % path)
	if err != OK:
		return null
	
	var img_tex := ImageTexture.new()
	img_tex.set_image(img)
	file.close()
	
	return img_tex


static func save_game_info(info: GameInfo) -> void:
	var cfg := ConfigFile.new()
	cfg.load(data_path)
	
	cfg.set_value(info.key, "title", info.title)
	cfg.set_value(info.key, "creator", info.creator)
	cfg.set_value(info.key, "description", info.description)
	cfg.set_value(info.key, "exe_file_path", info.exe_file_path)
	cfg.set_value(info.key, "logo_image_path", info.logo_image_path)
	cfg.set_value(info.key, "cover_image_path", info.cover_image_path)
	cfg.set_value(info.key, "screenshot_image_path", info.screenshot_image_path)
	
	cfg.save(data_path)


static func overwrite_all_game_info(all_info: Array[GameInfo]) -> void:
	var cfg := ConfigFile.new()
	
	for info in all_info:
		cfg.set_value(info.key, "title", info.title)
		cfg.set_value(info.key, "creator", info.creator)
		cfg.set_value(info.key, "description", info.description)
		cfg.set_value(info.key, "exe_file_path", info.exe_file_path)
		cfg.set_value(info.key, "logo_image_path", info.logo_image_path)
		cfg.set_value(info.key, "cover_image_path", info.cover_image_path)
		cfg.set_value(info.key, "screenshot_image_path", info.screenshot_image_path)
	
	cfg.save(data_path)


static func load_game_info(key: String) -> GameInfo:
	var cfg := ConfigFile.new()
	
	var err := cfg.load(data_path)
	if err != OK:
		return null
	
	var info := GameInfo.new(key)
	info.title = cfg.get_value(info.key, "title", "")
	info.creator = cfg.get_value(info.key, "creator", "")
	info.description = cfg.get_value(info.key, "description", "")
	info.exe_file_path = cfg.get_value(info.key, "exe_file_path", "")
	info.logo_image_path = cfg.get_value(info.key, "logo_image_path", "")
	info.cover_image_path = cfg.get_value(info.key, "cover_image_path", "")
	info.screenshot_image_path = cfg.get_value(info.key, "screenshot_image_path", "")
	
	return info


static func load_all_game_info() -> Array[GameInfo]:
	var cfg := ConfigFile.new()
	
	var err := cfg.load(data_path)
	if err != OK:
		return []
	
	var all_info: Array[GameInfo]
	for section in cfg.get_sections():
		all_info.push_back(load_game_info(section))
	
	return all_info


static func delete_game_info(key: String) -> void:
	var cfg := ConfigFile.new()
	
	var err := cfg.load(data_path)
	if err != OK:
		return
	
	cfg.erase_section(key)
	cfg.save(data_path)
