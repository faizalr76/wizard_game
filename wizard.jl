LOCATION = "living room"
NODES = Dict(
    "living room" => "You are in the living room. A wizard is snoring loudly on the couch.",
    "garden" => "You are in a beautiful garden. There is a wall in front of you.",
    "attic" => "You are in the attic. There is a giant wielding torch in the corner."
)

function main()
    println(NODES["living room"])
end

function main()
    println(look())
    println(pickup("bucket"))
    println(walk("west"))
    println(pickup("chain"))
    #println(pickup("frog"))
    println(inventory())
    println(walk("east"))
    println(walk("upstairs"))
    println(weld("chain", "bucket"))
    println(walk("downstairs"))
    println(walk("west"))
    println(dunk("bucket", "well"))
    println(walk("east"))
    println(splash("bucket", "wizard"))
end

function look()
    describe_location(LOCATION, NODES) *
    describe_paths(LOCATION, EDGES) *
    describe_objects(LOCATION, OBJECTS)
end

function describe_location(location, nodes)
    return nodes[location]
end

EDGES = Dict(
    "living room" => [Dict("place" => "garden", "dir" => "west", "means" => "door"), 
                    Dict("place" => "attic", "dir" => "upstairs", "means" => "ladder")],
    "garden" => [Dict("place" => "living room", "dir" => "east", "means" => "door")],
    "attic"  => [Dict("place" => "living room", "dir" => "downstairs", "means" => "ladder")]
)

function describe_path(edge)
    "There is a " * edge["place"] * " going " * edge["dir"] * " from here."
end

function describe_paths(location, edges)
    join(map(describe_path, edges[location]), " ")
end

OBJECTS = Dict( 
    "whiskey" => "living room", 
    "bucket"  => "living room", 
    "frog"    => "garden", 
    "chain"   => "garden"
)

function objects_at(loc, objs)
    ret = []
    for (k, v) in objs
        if v == loc
            push!(ret, k)
        end
    end
    ret
end

function describe_objects(loc, objs)
    arr = ["You see a " * obj * " on the floor." for obj in objects_at(loc, objs)]
    join(arr, " ")
end

function walk(dir)
    for edge in EDGES[LOCATION]
        if edge["dir"] == dir
            global LOCATION = edge["place"]
            return look()
        end
    end
    "You cannot go that way."
end

function pickup(obj)
    if obj in objects_at(LOCATION, OBJECTS)
        OBJECTS[obj] = "body"
        "You are now carrying the $obj."
    else
        "You cannot get that."
    end
end

function inventory()
    Dict("items" => objects_at("body", OBJECTS))
end

function have(obj)
    obj in inventory()["items"]
end

CHAIN_WELDED = false

function weld(subj, obj)
    if LOCATION == "attic" && 
       subj == "chain" && 
       obj == "bucket" && 
       have("chain")   && 
       have("bucket")  &&
       !CHAIN_WELDED   
        
        global CHAIN_WELDED = true
        return "The chain is now securely welded to the bucket.";
    else
        return "You cannot weld like that.";
    end
end

BUCKET_FILLED = false

function dunk(subj, obj)
    if  LOCATION === "garden" && 
        subj === "bucket" && 
        obj === "well" && 
        have("bucket") &&
        CHAIN_WELDED   

        global BUCKET_FILLED = true
        return "The bucket is now full of water."
    else
        return "You cannot dunk like that. The water level is too low to reach."
    end
end

function splash(subj, obj)
    if  LOCATION == "living room" && 
        subj == "bucket" && 
        obj == "wizard" && 
        have("bucket") 
        
        if !BUCKET_FILLED
            return "The bucket has nothing in it."
        elseif have("frog")
            return "The wizard awakens and sees that you stole his frog. He is so upset " *
            "he banishes you to the netherworld. You lose! The end."
        else
            return "The wizard awakens from his slumber and greets you warmly. He hands you the " *
            "magic low-carb donut. You win! The end."
        end
    end
end

main()

