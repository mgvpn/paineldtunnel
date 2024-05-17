class NoFoundCategory {
    constructor(root) {
        this.root = root
    }

    render() {
        this.root.innerHTML = `
            <div class="d-flex justify-content-center p-5">
                <h4 class="text-muted">LAMENTABLEMENTE NO ENCONTRAMOS NINGUNA CATEGORÍA</h4>
            </div>
        `
    }
}

export default NoFoundCategory