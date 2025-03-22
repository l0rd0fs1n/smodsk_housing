class PropertyDetails {
    static data = {};

    static SetData(data) {
        if (typeof data === "object" && data !== null) {
            this.data = data;
        }
    }

    static Set(key, value, post = false) {
        if (typeof this.data !== "object" || this.data === null) {
            this.data = {};
        }

        this.data[key] = value;

        if (post && typeof Post === "function") {
            Post({ key: key, value: value }, "SetPropertyDetailsValue");
        }
    }

    static Get(key) {
        return this.data[key];
    }
}
