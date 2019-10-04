import MPagesFusionCustomComponentBody from "../../../../main/js/cerner/mpagedev/component/controls/MPagesFusionCustomComponentBody";

const initialProps = {
    data: null
};

const createMPagesFusionCustomComponentBody = (props, children) => new MPagesFusionCustomComponentBody(props, children);
describe("The MPagesFusionCustomComponentBody", () => {
    let mpagesfusioncustomcomponentBody = null;
    describe("when constructed", () => {
        beforeEach(() => {
            mpagesfusioncustomcomponentBody = createMPagesFusionCustomComponentBody({}, []);
        });

        it("should have initial set of properties", () => {
            expect(mpagesfusioncustomcomponentBody.getProps()).toEqual(initialProps);
        });

        it("can be constructed without children", () => {
            expect(() => {
                createMPagesFusionCustomComponentBody({}, []);
            }).not.toThrow();
        });

        it("can be constructed without children and properties", () => {
            expect(() => {
                createMPagesFusionCustomComponentBody();
            }).not.toThrow();
        });
    });
});

