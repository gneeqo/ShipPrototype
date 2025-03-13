class_name GlobalExecutorList extends Node
# for pausing world space actions during UI
static var WorldSpacePaused : bool = false
static var UISpacePaused : bool = false

static func pause_world_executors():
    WorldSpacePaused = true
    
static func pause_UI_executors():
    UISpacePaused = true
    
    
static func unpause_world_executors():
    WorldSpacePaused = false
    
static func unpause_UI_executors():
    UISpacePaused = false
