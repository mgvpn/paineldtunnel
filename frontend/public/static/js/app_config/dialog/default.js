import AbsDialog from "./dialog.js";

export default class DialogDefault extends AbsDialog {
    render() {
        this.dialogHeader.setTitle('DIALOGO ESTANDAR');
        this.dialogHeader.setCloseButton(e => {
            e.stopPropagation();
            this.close();
        });
        this.dialogContent.element.innerText = 'ESTE ES UN DIALOGO ESTANDAR (CHECKUSER, MENSAJE ETC...)'
        this.setStyle({ 'text-align': 'center' });
        super.render();
    }
}
