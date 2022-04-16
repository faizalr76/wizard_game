Object.prototype.keys = function () { return Object.keys(this); };

let LOCATION = "living room";
let NODES = {
    "living room": "You are in the living room. A wizard is snoring loudly on the couch.",
    "garden": "You are in a beautiful garden. There is a wall in front of you.",
    "attic": "You are in the attic. There is a giant wielding torch in the corner."
};

function main () {
    let x;

    x = look();
    console.log(x);

    console.log(pickup("bucket"));
    console.log(walk("west"));
    console.log(pickup("chain"));
    console.log(pickup("frog"));
    console.log(inventory());
    console.log(walk("east"));
    console.log(walk("upstairs"));
    console.log(weld("chain", "bucket"));
    console.log(walk("downstairs"));
    console.log(walk("west"));
    //console.log(dunk("bucket", "well"));
    console.log(walk("east"));
    console.log(splash("bucket", "wizard"));
}

function look () {
    return describe_location(LOCATION, NODES) +
           describe_paths(LOCATION, EDGES) +
           describe_objects(LOCATION, OBJECTS);
}

function describe_location (location, nodes) {
    return nodes[location];
}

let EDGES = {
    "living room": [{"place": "garden", "dir": "west", "means": "door"}, 
                    {"place": "attic", "dir": "upstairs", "means": "ladder"}],
    "garden": [{"place": "living room", "dir": "east", "means": "door"}],
    "attic" : [{"place": "living room", "dir": "downstairs", "means": "ladder"}]
};

function describe_path (edge) {
    return "There is a " + edge["place"] + " going " + edge["dir"] + " from here.";
}

function describe_paths (location, edges) {
    return edges[location].map(describe_path).join(" ");
}

let OBJECTS = {
    "whiskey": "living room", 
    "bucket": "living room", 
    "frog": "garden", 
    "chain": "garden"
};

function objects_at (loc, objs) {
    return objs.keys().filter(function (k) {
        return objs[k] === loc;
    });
}

function describe_objects (loc, objs) {
    return objects_at(loc, objs)
        .map(function (obj) { 
            return "You see a " + obj + " on the floor."; })
        .join(" ");
}

function walk (dir) {
    let next = EDGES[LOCATION].filter(function (x) {
        return x["dir"] === dir;
    })[0];
    if (next) {
        LOCATION = next["place"];
        return look();
    }
    else {
        return "You cannot go that way.";
    };
}

function pickup (obj) {
    if (objects_at(LOCATION, OBJECTS).indexOf(obj) > -1) {
        OBJECTS[obj] = "body";
        return "You are now carrying the " + obj + ".";
    }
    else {
        return "You cannot get that.";
    }
}

function inventory () {
    return {"items": objects_at("body", OBJECTS)};
}

function have (obj) {
    return inventory()["items"].includes(obj);
}

let CHAIN_WELDED = undefined;

function weld (subj, obj) {
    if (LOCATION === "attic" && 
        subj === "chain" && 
        obj === "bucket" && 
        have("chain") && 
        have("bucket") &&
        !CHAIN_WELDED) {
        CHAIN_WELDED = true;
        return "The chain is now securely welded to the bucket.";
    }
    else {
        return "You cannot weld like that.";
    }
}

let BUCKET_FILLED;

function dunk (subj, obj) {
    if (LOCATION === "garden" && 
        subj === "bucket" && 
        obj === "well" && 
        have("bucket") &&
        CHAIN_WELDED) {
        BUCKET_FILLED = true;
        return "The bucket is now full of water.";
    }
    else {
        return "You cannot dunk like that. The water level is too low to reach.";
    }
}

function splash (subj, obj) {
    if (LOCATION === "living room" && 
        subj === "bucket" && 
        obj === "wizard" && 
        have("bucket") 
        ) {
        if (!BUCKET_FILLED) {
            return "The bucket has nothing in it.";
        }
        else if (have("frog")) {
            return "The wizard awakens and sees that you stole his frog. He is so upset " +
            "he banishes you to the netherworld. You lose! The end.";
        }
        else {
            return "The wizard awakens from his slumber and greets you warmly. He hands you the " +
            "magic low-carb donut. You win! The end."
        }
    }
}

main ();
