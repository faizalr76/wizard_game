
LOCATION = "living room"
NODES = {
    "living room": "You are in the living room. A wizard is snoring loudly on the couch.",
    "garden": "You are in a beautiful garden. There is a wall in front of you.",
    "attic": "You are in the attic. There is a giant wielding torch in the corner."
}

def main ():
    print(look())
    print(pickup("bucket"))
    print(walk("west"))
    print(pickup("chain"))
    print(pickup("frog"))
    print(inventory())
    print(walk("east"))
    print(walk("upstairs"))
    print(weld("chain", "bucket"))
    print(walk("downstairs"))
    print(walk("west"))
    print(dunk("bucket", "well"))
    print(walk("east"))
    print(splash("bucket", "wizard"))

def look ():
    return describe_location(LOCATION, NODES) \
           + describe_paths(LOCATION, EDGES)  \
           + describe_objects(LOCATION, OBJECTS)

def describe_location (location, nodes) :
    return nodes[location]

EDGES = {
    "living room": [{"place": "garden", "dir": "west", "means": "door"}, 
                    {"place": "attic", "dir": "upstairs", "means": "ladder"}],
    "garden": [{"place": "living room", "dir": "east", "means": "door"}],
    "attic" : [{"place": "living room", "dir": "downstairs", "means": "ladder"}]
}

def describe_path (edge) :
    return "There is a " + edge["place"] + " going " + edge["dir"] + " from here."

def describe_paths (location, edges) :
    return " ".join(map(describe_path, edges[location]))

OBJECTS = {
    "whiskey": "living room", 
    "bucket": "living room", 
    "frog": "garden", 
    "chain": "garden"
}

def objects_at (loc, objs):
    ret = []
    for k, v in objs.items():
        if v == loc:
            ret.append(k)
    return ret

def describe_objects (loc, objs):
    ret = []
    for obj in objects_at(loc, objs):
        ret.append("You see a " + obj + " on the floor.")
    return " ".join(ret)

def walk (dir):
    global LOCATION, EDGES
    next_loc = ""
    for edge in EDGES[LOCATION]:
        if edge["dir"] == dir:
            LOCATION = edge["place"]
            return look()
    return "You cannot go that way."

def pickup (obj):
    global LOCATION, OBJECTS
    if obj in objects_at(LOCATION, OBJECTS):
        OBJECTS[obj] = "body"
        return "You are now carrying the " + obj + "."
    else:
        return "You cannot get that."

def inventory ():
    global OBJECTS 
    return {"items": objects_at("body", OBJECTS)} 

def have (obj):
    return  obj in inventory()["items"]

CHAIN_WELDED = False

def weld (subj, obj):
    global LOCATION, CHAIN_WELDED
    if LOCATION == "attic" \
       and subj == "chain" \
       and obj == "bucket" \
       and have("chain")   \
       and have("bucket")  \
       and not CHAIN_WELDED:

       CHAIN_WELDED = True
       return "The chain is now securely welded to the bucket."
    else:
        return "You cannot weld like that."

BUCKET_FILLED = False

def dunk (subj, obj):
    global LOCATION, CHAIN_WELDED, BUCKET_FILLED
    if LOCATION == "garden" \
       and subj == "bucket" \
       and obj == "well"    \
       and have("bucket")   \
       and CHAIN_WELDED:

       BUCKET_FILLED = True
       return "The bucket is now full of water."
    else:
        return "You cannot dunk like that. The water level is too low to reach."

def splash (subj, obj):
    global LOCATION, BUCKET_FILLED
    if LOCATION == "living room" \
       and subj == "bucket" \
       and obj == "wizard"  \
       and have("bucket"):
        if not BUCKET_FILLED:
            return "The bucket has nothing in it."
        elif have("frog"):
            return "The wizard awakens and sees that you stole his frog. He is so upset " \
                 + "he banishes you to the netherworld. You lose! The end."
        else:
            return "The wizard awakens from his slumber and greets you warmly. He hands you the " \
                 + "magic low-carb donut. You win! The end."

main()
