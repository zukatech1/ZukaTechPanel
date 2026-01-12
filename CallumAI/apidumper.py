import json

API_DUMP_PATH = r"C:\Users\zuka\AppData\Local\RobloxApiDumpFiles\api-dump.txt"  # your file

def load_api_dump(path):
    with open(path, "r", encoding="utf-8-sig") as f:
        return json.load(f)

def build_api_index(api_dump):
    index = {}

    for cls in api_dump.get("Classes", []):
        name = cls["Name"]

        index[name] = {
            "inherits": cls.get("Superclass"),
            "properties": [],
            "methods": [],
            "events": []
        }

        for member in cls.get("Members", []):
            mtype = member.get("MemberType")
            mname = member.get("Name")

            if mtype == "Property":
                index[name]["properties"].append(mname)
            elif mtype == "Function":
                index[name]["methods"].append(mname)
            elif mtype == "Event":
                index[name]["events"].append(mname)

    return index

if __name__ == "__main__":
    dump = load_api_dump(API_DUMP_PATH)
    api_index = build_api_index(dump)

    print(f"Loaded {len(api_index)} Roblox classes.")
    print("Example: Part →", api_index.get("Part"))

    import pickle
    with open("roblox_api_index.pkl", "wb") as f:
        pickle.dump(api_index, f)

    print("Saved roblox_api_index.pkl")
    print(f"Loaded {len(api_index)} Roblox classes.")
    print("Example: Part →", api_index.get("Part"))
