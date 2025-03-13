class_name TelemetryCollector extends Node

#first timestamp, second information
# array contains a float at 0 and a string at 1, 2 and 3
static var events_recorded : Array[Array]

static var telemetry_active : bool = false



static func add_event(target:String,verb:String,content:String):
    if not telemetry_active:
        pass
    else:
        #get current time
        var timestamp = Time.get_unix_time_from_system()
        #add event to list
        events_recorded.push_back([timestamp,target,verb,content])

static func start_collecting():	
    events_recorded.clear()
    telemetry_active = true
    
static func finish_collecting():
    telemetry_active = false
    write_telemetry()
    
static func write_telemetry():
    var full_content:String = "Timestamp, Subject, Verb, Complement\n"
    
    for event in events_recorded:
        full_content = full_content + str(event[0])\
        + "," + event[1] +  "," + event[2] + "," + event[3] +"\n"

    var file = FileAccess.open("user://telemetry.csv", FileAccess.WRITE)
    file.store_string(full_content)
