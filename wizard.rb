
$location = "living room"
$nodes = {
    "living room" => "You are in the living room. A wizard is snoring loudly on the couch.",
    "garden" => "You are in a beautiful garden. There is a wall in front of you.",
    "attic" => "You are in the attic. There is a giant wielding torch in the corner."
}

def main ()
    puts(look())
    puts(pickup("bucket"))
    puts(walk("west"))
    puts(pickup("chain"))
    puts(pickup("frog"))
    puts(inventory())
    puts(walk("east"))
    puts(walk("upstairs"))
    puts(weld("chain", "bucket"))
    puts(walk("downstairs"))
    puts(walk("west"))
    puts(dunk("bucket", "well"))
    puts(walk("east"))
    puts(splash("bucket", "wizard"))
end

def look ()
    describe_location($location, $nodes) +
    describe_paths($location, $edges) +
    describe_objects($location, $objects)
end

def describe_location (location, nodes)
    nodes[location]
end

$edges = {
    "living room" => [{"place" => "garden", "dir" => "west", "means" => "door"}, 
                    {"place" => "attic", "dir" => "upstairs", "means" => "ladder"}],
    "garden" => [{"place" => "living room", "dir" => "east", "means" => "door"}],
    "attic"  => [{"place" => "living room", "dir" => "downstairs", "means" => "ladder"}]
}

def describe_path (edge)
    "There is a " + edge["place"] + " going " + edge["dir"] + " from here."
end

def describe_paths (location, edges)
    places = edges[location]
    ret = []
    for place in places
        ret.push(describe_path(place))
    end
    ret.join(" ")
end

$objects = {
    "whiskey" => "living room", 
    "bucket" => "living room", 
    "frog" => "garden", 
    "chain" => "garden"
}

def objects_at (loc, objs)
    ret = []
    objs.each do |k, v|
        if v == loc
            ret.push(k)
        end
    end
    return ret
end

def describe_objects (loc, objs)
    ret = []
    objects_at(loc, objs).each do |obj|
        ret.push("You see a " + obj + " on the floor.")
    end
    ret.join(" ")
end

def walk (dir)
    next_loc = ""
    for edge in $edges[$location]
        if edge["dir"] == dir
            $location = edge["place"]
            return look()
        end
    end
    return "You cannot go that way."
end

def pickup (obj)
    objs = objects_at($location, $objects)
    if objs.include? obj then
        $objects[obj] = "body"
        return "You are now carrying the " + obj + "."
    else
        return "You cannot get that."
    end
end

def inventory ()
    return {"items": objects_at("body", $objects)} 
end

def have (obj)
    inventory()[:items]&.include?(obj)
end

$chain_welded = false

def weld (subj, obj)
    puts(inventory())
    if $location == "attic" and 
       subj == "chain" and 
       obj == "bucket" and 
       have("chain")   and 
       have("bucket")  and 
       !$chain_welded then

       $chain_welded = true
       return "The chain is now securely welded to the bucket."
    else
        return "You cannot weld like that."
    end
end

$bucket_filled = false

def dunk (subj, obj)
    if $location == "garden" and
       subj == "bucket" and
       obj == "well"    and 
       have("bucket")   and 
       $chain_welded    then

       $bucket_filled = true
       return "The bucket is now full of water."
    else
        return "You cannot dunk like that. The water level is too low to reach."
    end
end

def splash (subj, obj)
    if $location == "living room" and
       subj == "bucket" and 
       obj == "wizard"  and
       have("bucket")  then
        if not $bucket_filled then
            return "The bucket has nothing in it."
        elsif have("frog") then
            return "The wizard awakens and sees that you stole his frog. He is so upset " +
                   "he banishes you to the netherworld. You lose! The end."
        else
            return "The wizard awakens from his slumber and greets you warmly. He hands you the " +
                   "magic low-carb donut. You win! The end."
        end
    end
end

main()
