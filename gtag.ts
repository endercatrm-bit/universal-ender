// ii's Quest Menu, by @goldentrophy / @crimsoncauldron
// Warning: Ugly code. I hate TypeScript.

declare const Il2Cpp: any;
declare const console: any;
declare const XRNode: any;
declare const Java: any;

const version = "1.4.1";
let boardMaterial = null;
let buttonClickDelay = 0.0;
let menu = null;
let reference = null;
let referenceCollider = null;

let leftPrimary = false;
let leftSecondary = false;

let rightPrimary = false;
let rightSecondary = false;

let leftGrab = false;
let rightGrab = false;

let leftTrigger = false;
let rightTrigger = false;

let deltaTime = 0.0;
let time = 0.0;
let frameCount = 0;

let buttonSound = 8;
let LerpMenu = false;
let menuscale = 1;
let flySpeed = 25.0;

let previousGhostKey = false;
let previousInvisKey = false;
let previousNoclipKey = false;
let perviousTeleportKey = false;

let walkPos = null;
let walkNormal = null;

let previousDash = false;

let closePosition = null;
let tagGunDelay = 0.0;
let idGunDelay = 0.0;
let splashDelay = 0.0;
let lagGunDelay = 0.0;

let lastTime = 0.0;
let oldSlide = null;

let leftPlatform = null;
let rightPlatform = null;

let checkpoint = null;
let positions = [];

let lineRenderHolder = null;
let isLineRenderQueued = false;
let linePool = [];

let lvT = null;
let rvT = null;

let buttonNotifications: boolean = true;
let enabledRecent: boolean = false;

let highPunchPower = false;

let espCollide = false;

let bgColor: [number, number, number, number] = [0.5, 0.0, 0.8, 1.0];
let textColor: [number, number, number, number] = [0.9, 0.8, 1.0, 1.0];

let buttonColor: [number, number, number, number] = [0.25, 0.0, 0.4, 1.0];
let buttonPressedColor: [number, number, number, number] = [0.6, 0.2, 1.0, 1.0];

let menuName: string = "endercat menu STANDALONE";
let themeIndex = 0;
let buttonIndex = 0;
let favoriteColor = 2;

let currentNotification: string = "";
let notifactionResetTime: number = 0;

Il2Cpp.perform(() => {
    const images = {
        "Assembly-CSharp": Il2Cpp.domain.assembly("Assembly-CSharp").image,
        "UnityEngine.CoreModule": Il2Cpp.domain.assembly("UnityEngine.CoreModule").image,
        "UnityEngine.PhysicsModule": Il2Cpp.domain.assembly("UnityEngine.PhysicsModule").image,
        "UnityEngine.UIModule": Il2Cpp.domain.assembly("UnityEngine.UIModule").image,
        "UnityEngine.UI": Il2Cpp.domain.assembly("UnityEngine.UI").image,
        "UnityEngine.TextRenderingModule": Il2Cpp.domain.assembly("UnityEngine.TextRenderingModule").image,
        "PhotonUnityNetworking": Il2Cpp.domain.assembly("PhotonUnityNetworking").image,
        "Unity.TextMeshPro": Il2Cpp.domain.assembly("Unity.TextMeshPro").image,
    };

    const AssemblyCSharp = images["Assembly-CSharp"];
    const UnityEngineCore = images["UnityEngine.CoreModule"];
    const UnityEnginePhysics = images["UnityEngine.PhysicsModule"];
    const UnityEngineUI = images["UnityEngine.UI"];
    const UnityEngineUIModule = images["UnityEngine.UIModule"];
    const UnityEngineTextRendering = images["UnityEngine.TextRenderingModule"];
    const PhotonUnityNetworking = images["PhotonUnityNetworking"];
    const UnityTextMeshPro = images["Unity.TextMeshPro"];

    const ControllerInputPoller = AssemblyCSharp.class("ControllerInputPoller").field("instance").value;
    const GorillaTaggerClass = AssemblyCSharp.class("GorillaTagger");
    const GTPlayerClass = AssemblyCSharp.class("GorillaLocomotion.GTPlayer");
    const VRRig = AssemblyCSharp.class("VRRig");
    const MonkeAgent = AssemblyCSharp.class("MonkeAgent");
    const GorillaParentClass = AssemblyCSharp.class("GorillaParent");
    const NetworkSystemClass = AssemblyCSharp.class("NetworkSystem");
    const GorillaReportButton = AssemblyCSharp.class("GorillaReportButton");
    const FreeHoverboardManager = AssemblyCSharp.class("FreeHoverboardManager").method("get_instance").invoke();
    const GameMode = AssemblyCSharp.class("GorillaGameModes.GameMode");
    const FriendshipGroupDetection = AssemblyCSharp.class("GorillaTagScripts.FriendshipGroupDetection").method("get_Instance").invoke();
    const GorillaVelocityTracker = AssemblyCSharp.class("GorillaLocomotion.Climbing.GorillaVelocityTracker");
    const PhotonNetwork = PhotonUnityNetworking.class("Photon.Pun.PhotonNetwork");
    const RpcTarget = PhotonUnityNetworking.class("Photon.Pun.RpcTarget");

    const GameObject = UnityEngineCore.class("UnityEngine.GameObject");
    const Object = UnityEngineCore.class("UnityEngine.Object");
    const SystemObject = Il2Cpp.corlib.class("System.Object");
    const Thread = Il2Cpp.corlib.class("System.Threading.Thread");
    const Vector3 = UnityEngineCore.class("UnityEngine.Vector3");
    const Quaternion = UnityEngineCore.class("UnityEngine.Quaternion");
    const Time = UnityEngineCore.class("UnityEngine.Time");
    const Resources = UnityEngineCore.class("UnityEngine.Resources");
    const Material = UnityEngineCore.class("UnityEngine.Material");
    const Renderer = UnityEngineCore.class("UnityEngine.Renderer");
    const Shader = UnityEngineCore.class("UnityEngine.Shader");
    const Color = UnityEngineCore.class("UnityEngine.Color");
    const RectTransform = UnityEngineCore.class("UnityEngine.RectTransform");
    const LineRenderer = UnityEngineCore.class("UnityEngine.LineRenderer");
    const PlayerPrefs = UnityEngineCore.class("UnityEngine.PlayerPrefs");

    const MeshCollider = UnityEnginePhysics.class("UnityEngine.MeshCollider");
    const BoxCollider = UnityEnginePhysics.class("UnityEngine.BoxCollider");
    const SphereCollider = UnityEnginePhysics.class("UnityEngine.SphereCollider");
    const CapsuleCollider = UnityEnginePhysics.class("UnityEngine.CapsuleCollider");
    const Collider = UnityEnginePhysics.class("UnityEngine.Collider");
    const Rigidbody = UnityEnginePhysics.class("UnityEngine.Rigidbody");
    const Physics = UnityEnginePhysics.class("UnityEngine.Physics");
    const Ray = UnityEngineCore.class("UnityEngine.Ray");
    const RaycastHit = UnityEnginePhysics.class("UnityEngine.RaycastHit");

    const Canvas = UnityEngineUIModule.class("UnityEngine.Canvas");
    const CanvasScaler = UnityEngineUI.class("UnityEngine.UI.CanvasScaler");
    const GraphicRaycaster = UnityEngineUI.class("UnityEngine.UI.GraphicRaycaster");
    const Text = UnityEngineUI.class("UnityEngine.UI.Text");
    const Font = UnityEngineTextRendering.class("UnityEngine.Font");

    const TextMeshPro = UnityTextMeshPro.class("TMPro.TextMeshPro");

    const GorillaTagger = GorillaTaggerClass.field("_instance").value;
    const GorillaParent = GorillaParentClass.field("instance").value;
    const MonkeAgentInst = MonkeAgent.field("instance").value;
    const NetworkSystem = NetworkSystemClass.field("Instance").value;
    const rigidbody = GorillaTagger.field("<rigidbody>k__BackingField").value;

    const LocalRig = GorillaTagger.field("offlineVRRig").value;
    const GTPlayer = GTPlayerClass.field("_instance").value;
    const GorillaComputer = Il2Cpp.domain.assembly("Assembly-CSharp").image.class("GorillaNetworking.GorillaComputer").field("instance").value;

    const UberShader = Shader.method("Find").invoke(Il2Cpp.string("GorillaTag/UberShader"));
    const TextShader = Shader.method("Find").invoke(Il2Cpp.string("GUI/Text Shader"));

    const GorillaSurfaceOverride = AssemblyCSharp.class("GorillaSurfaceOverride");

    const zeroVector = Vector3.field("zeroVector").value;
    const oneVector = Vector3.field("oneVector").value;
    const identityQuaternion = Quaternion.field("identityQuaternion").value;

    const leftHandTransform = GorillaTagger.field("leftHandTransform").value;
    const rightHandTransform = GorillaTagger.field("rightHandTransform").value;
    const headCollider = GorillaTagger.field("headCollider").value;
    const bodyCollider = GorillaTagger.field("bodyCollider").value;

    const punchLastLeft = [zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector];
    const punchLastRight = [zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector, zeroVector];

    let LPrev = Vector3.field("zeroVector").value;
    let RPrev = Vector3.field("zeroVector").value;
    let LVel = Vector3.field("zeroVector").value;
    let RVel = Vector3.field("zeroVector").value;
    let AvgVel = Vector3.field("zeroVector").value;

    let righthand = false;

    const arial = Resources
        .method("GetBuiltinResource", 1)
        .inflate(Font)
        .invoke(Il2Cpp.string("Arial.ttf"));

    function Destroy(object) {
        Object.method("Destroy", 1).invoke(object);
    }

    function getComponent(obj: any, type) {
        return obj.method("GetComponent", 1).inflate(type).invoke();
    }

    function getComponentInParent(obj: any, type) {
        return obj.method("GetComponentInParent", 0).inflate(type).invoke();
    }

    function addComponent(obj: any, type) {
        return obj.method("AddComponent", 1).inflate(type).invoke();
    }

    function getOrAddComponent(obj: any, type) {
        let returnType = getComponent(obj, type);
        if (returnType != null && returnType != undefined) {
            return returnType
        }
        return addComponent(obj, type);
    }

    function getObject(obj) {
        return GameObject.method("Find", 1).invoke(Il2Cpp.string(obj));
    }

    function playerIsLocal(player) {
        return player.method("get_isLocal").invoke();
    }

    function setPlayerName(name) {
        GorillaComputer.field("currentName").value = Il2Cpp.string(name);
        GorillaComputer.field("savedName").value = Il2Cpp.string(name);

        PlayerPrefs.method("SetString").invoke(Il2Cpp.string("playerName"), Il2Cpp.string(name))
        PlayerPrefs.method("Save").invoke();

        PhotonNetwork.method("get_LocalPlayer").invoke().method("set_NickName").invoke(Il2Cpp.string(name));
    }

    function setPlayerColor(color) {
        PlayerPrefs.method("SetFloat").invoke(Il2Cpp.string("redValue"), color[0]);
        PlayerPrefs.method("SetFloat").invoke(Il2Cpp.string("greenValue"), color[1]);
        PlayerPrefs.method("SetFloat").invoke(Il2Cpp.string("blueValue"), color[2]);
        PlayerPrefs.method("Save").invoke();

        GorillaTagger.method("UpdateColor").invoke(color[0], color[1], color[2]);
        const objectArray = Il2Cpp.array(SystemObject, [
            Il2Cpp.reference(color[0], Il2Cpp.Type.Enum.FLOAT),
            Il2Cpp.reference(color[1], Il2Cpp.Type.Enum.FLOAT),
            Il2Cpp.reference(color[2], Il2Cpp.Type.Enum.FLOAT)
        ]);

        const method = GorillaTagger.method("get_myVRRig").invoke().method("SendRPC", 3).overload(
            "System.String",
            "Photon.Pun.RpcTarget",
            "System.Object[]");

        method.invoke(Il2Cpp.string("RPC_InitializeNoobMaterial"), 0, objectArray);
    }

    function getTransform(obj: any) {
        return obj.method("get_transform").invoke();
    }

    function world2Player(position) {
        position = Vector3.method("op_Subtraction", 2).invoke(position, getTransform(bodyCollider).method("get_position").invoke());
        position = Vector3.method("op_Addition", 2).invoke(position, getTransform(GorillaTagger).method("get_position").invoke());
        return position;
    }

    function teleportPlayer(position) {
        GTPlayer.method("TeleportTo", 3).invoke(world2Player(position), getTransform(GTPlayer).method("get_rotation").invoke(), false);
    }

    function sendAllOutgoing() {
        MonkeAgentInst.field("rpcErrorMax").value = Number.MAX_SAFE_INTEGER;
        MonkeAgentInst.field("rpcCallLimit").value = Number.MAX_SAFE_INTEGER;
        MonkeAgentInst.field("logErrorMax").value = Number.MAX_SAFE_INTEGER;
        PhotonNetwork.method("set_MaxResendsBeforeDisconnect").invoke(Number.MAX_SAFE_INTEGER);
        PhotonNetwork.method("set_QuickResends").invoke(Number.MAX_SAFE_INTEGER);
        PhotonNetwork.method("SendAllOutgoingCommands").invoke();
    }

    function serialize() {
        PhotonNetwork.method("RunViewUpdate").invoke();
    }

    function renderMenuText(
        canvasObject,
        text: string = "",
        color: [number, number, number, number] = [1, 1, 1, 1],
        pos = zeroVector,
        size = oneVector
    ) {
        const title = addComponent(createObject(zeroVector, identityQuaternion, oneVector, 3, [0, 0, 0, 0], getTransform(canvasObject)), Text);
        title.method("set_text").invoke(Il2Cpp.string(text));
        title.method("set_font").invoke(arial);
        title.method("set_fontSize").invoke(1);
        title.method("set_color").invoke(color);
        title.method("set_fontStyle").invoke(2);
        title.method("set_alignment").invoke(4);
        title.method("set_resizeTextForBestFit").invoke(true);
        title.method("set_resizeTextMinSize").invoke(0);

        const rectTransform = getComponent(title, RectTransform);
        rectTransform.method("set_sizeDelta").invoke(size);
        rectTransform.method("set_position").invoke(pos);
        rectTransform.method("set_rotation").invoke(Quaternion.method("Euler").invoke(180.0, 90.0, 90.0))
    }

    function createMaterial(shader) {
        const material = Material.new();
        return Material.method("CreateWithShader").invoke(material, shader);
    }

    function createObject(
        pos = zeroVector,
        rot = identityQuaternion,
        scale = oneVector,
        primitiveType: number = 3,
        colorArr: [number, number, number, number] = [1, 1, 1, 1],
        parent = null
    ) {
        const obj = GameObject.method("CreatePrimitive").invoke(primitiveType);

        const renderer = getComponent(obj, Renderer);

        if (colorArr[3] == 0) {
            renderer.method("set_enabled").invoke(false);
        } else {
            const material = renderer.method("get_material").invoke(); material.method("set_shader").invoke(UberShader); material.method("set_color").invoke(colorArr);
        }

        const transform = getTransform(obj);
        if (parent != null) {
            transform.method("SetParent", 2).invoke(parent, false);
        }

        transform.method("set_position").invoke(pos);
        transform.method("set_rotation").invoke(rot);
        transform.method("set_localScale").invoke(scale);

        return obj;
    }

    function sendNotification(NotificationText: string = "", requiresReload: boolean = true, clearTime: number = 5) {
        const isOld = (currentNotification == NotificationText);
        notifactionResetTime = time + clearTime;
        currentNotification = NotificationText;
        if (requiresReload && !isOld)
            reloadMenu();
    }

    function renderMenu() {
        menu = createObject(zeroVector, identityQuaternion, [0.1, 0.3, 0.3825], 3, [0, 0, 0, 0]);
        Destroy(getComponent(menu, BoxCollider))

        const menuBackground = createObject([0.1, 0, 0], identityQuaternion, [0.1, 1, 1], 3, bgColor, getTransform(menu))
        Destroy(getComponent(menuBackground, BoxCollider))

        const canvasObject = createObject(zeroVector, identityQuaternion, oneVector, 3, [0, 0, 0, 0], getTransform(menu));
        const canvas = addComponent(canvasObject, Canvas);
        Destroy(getComponent(canvasObject, BoxCollider))

        const canvasScaler = addComponent(canvasObject, CanvasScaler);
        addComponent(canvasObject, GraphicRaycaster);
        canvas.method("set_renderMode").invoke(2);
        canvasScaler.method("set_dynamicPixelsPerUnit").invoke(1000.0);

        renderMenuText(canvasObject, menuName + `<color=grey>[</color><color=white>${currentPage + 1}</color><color=grey>]</color>`, textColor, [0.11, 0, 0.175], [1, 0.1]);

        if (time > notifactionResetTime)
            currentNotification = "";
        renderMenuText(canvasObject, currentNotification, textColor, [0.11, 0, 0.275], [1, 0.1]);

        const disconnectButton = createObject([0.1, 0.0, 0.225], identityQuaternion, [0.09, 0.9, 0.08], 3, buttonColor, getTransform(menu));
        disconnectButton.method("set_name").invoke(Il2Cpp.string("@Disconnect"));

        addComponent(disconnectButton, GorillaReportButton);
        getComponent(disconnectButton, BoxCollider).method("set_isTrigger").invoke(true);
        renderMenuText(canvasObject, "Disconnect", textColor, [0.11, 0, 0.225], [1, 0.1]);

        const returnButton = createObject([0.1, -0.175, -0.225], identityQuaternion, [0.09, 0.09, 0.09], 3, buttonColor, getTransform(menu));
        returnButton.method("set_name").invoke(Il2Cpp.string("@GlobalReturn"));

        addComponent(returnButton, GorillaReportButton);
        getComponent(returnButton, BoxCollider).method("set_isTrigger").invoke(true);
        renderMenuText(canvasObject, "<", textColor, [0.11, -0.175, -0.225], [1, 0.1]);

        {
            const pageButton = createObject([0.1, 0.2, 0], identityQuaternion, [0.09, 0.2, 0.9], 3, buttonColor, getTransform(menu));
            pageButton.method("set_name").invoke(Il2Cpp.string("@PreviousPage"));

            addComponent(pageButton, GorillaReportButton);
            getComponent(pageButton, BoxCollider).method("set_isTrigger").invoke(true);
            renderMenuText(canvasObject, "<", textColor, [0.11, 0.2, 0], [1, 0.1]);
        }

        {
            const pageButton = createObject([0.1, -0.2, 0], identityQuaternion, [0.09, 0.2, 0.9], 3, buttonColor, getTransform(menu));
            pageButton.method("set_name").invoke(Il2Cpp.string("@NextPage"));

            addComponent(pageButton, GorillaReportButton);
            getComponent(pageButton, BoxCollider).method("set_isTrigger").invoke(true);
            renderMenuText(canvasObject, ">", textColor, [0.11, -0.2, 0], [1, 0.1]);
        }

        let i = 0;
        const targetMods = buttons[currentCategory]
            .slice(currentPage * 8)
            .slice(0, 8);
        
        const favorited = [];
        buttons[11].forEach((buttonData) => {
            if (buttonData.buttonText != "Exit Favorite Mods")
                favorited.push(buttonData.buttonText);
        });
        const favTextColor: [number, number, number, number] = [
            Math.max( Math.min(textColor[0] + (favoriteColor == 0 ? (+1.0) : 0.2), 1), 0 ),
            Math.max( Math.min(textColor[1] + (favoriteColor == 1 ? (-0.1) : (favoriteColor == 0 ? (-0.1) : 0.2)), 1), 0 ),
            Math.max( Math.min(textColor[2] + (favoriteColor == 2 ? (-0.1) : (favoriteColor == 0 ? (-0.2) : 0.2)), 1), 0 ),
            Math.max( Math.min(textColor[3] + (favoriteColor == 3 ? (-0.7) : 0.0), 1), 0 )
        ]
        
        targetMods.forEach((buttonData, index) => {
            const button = createObject([0.105, 0, 0.13 - (i * 0.04)], identityQuaternion, [0.09, 0.9, 0.08], 3, buttonColor, getTransform(menu));
            button.method("set_name").invoke(Il2Cpp.string("@" + buttonData.buttonText));

            addComponent(button, GorillaReportButton);
            getComponent(button, BoxCollider).method("set_isTrigger").invoke(true);
            renderMenuText(canvasObject, buttonData.buttonText, favorited.includes(buttonData.buttonText) ? favTextColor : textColor, [0.11, 0, 0.13 - (i * 0.04)], [1, 0.1]);
            updateButtonColor(button, buttonData);
            i++;
        });
        getTransform(menu).method("set_localScale").invoke(Vector3.method("op_Multiply").invoke(Vector3.method("op_Multiply").invoke(getTransform(menu).method("get_localScale").invoke(), GTPlayer.field("nativeScale").value), menuscale));
        recenterMenu();
    }

    function renderReference() {
        if (righthand) {
            reference = createObject(zeroVector, identityQuaternion, [0.01, 0.01, 0.01], 0, bgColor, leftHandTransform)
            referenceCollider = getComponent(reference, Collider);

            getTransform(reference).method("set_localPosition").invoke([0.01, -0.117, 0.05]);
            reference.method("set_layer").invoke(2);
            addComponent(reference, Rigidbody).method("set_isKinematic").invoke(true);
        }
        else {
            reference = createObject(zeroVector, identityQuaternion, [0.01, 0.01, 0.01], 0, bgColor, rightHandTransform)
            referenceCollider = getComponent(reference, Collider);

            getTransform(reference).method("set_localPosition").invoke([0.01, -0.117, 0.05]);
            reference.method("set_layer").invoke(2);
            addComponent(reference, Rigidbody).method("set_isKinematic").invoke(true);
        }
    }
    
    function toggleFavorite(info: ButtonInfo) {
        let exists = false;
        for (let index = 0; index < buttons[11].length; index++) {
            const mod = buttons[11][index];
            if (mod.buttonText == info.buttonText)
            {
                exists = true;
                break;
            }
        }
        if (exists) {
            if (info.buttonText == "Exit Favorite Mods")
                return;
            for (let index = 0; index < buttons[11].length; index++) {
                const mod = buttons[11][index];
                if (mod.buttonText == info.buttonText)
                {
                    buttons[11].splice(index, 1);
                    break;
                }
            }
        } else {
            if (info.buttonText == "Exit Favorite Mods")
                return;
            buttons[11].push(info);
        }
    }
    function loadEnabled() {
        buttons[12].splice(1);
        buttons.forEach((buttonList, index) => {
            if (index != 12 && index != 11) {
                buttonList.forEach(button => {
                    if (button.enabled)
                        buttons[12].push(button);
                });
            }
        });
    }

    let gunLocked = false;
    let lockTarget = null;
    let GunPointer = null;
    let GunLine = null;
    function renderGun(overrideLayerMask = null) {
        const StartPosition = rightHandTransform.method("get_position").invoke();
        const Direction = rightHandTransform.method("get_forward").invoke();

        const DirectionDivided = Vector3.method("op_Division").invoke(Direction, 4);
        const rayStartPosition = Vector3.method("op_Addition").invoke(StartPosition, DirectionDivided);

        const layerMask = overrideLayerMask || -3180559;

        const hits = Physics.method("RaycastAll", 4).invoke(
            rayStartPosition,
            Direction,
            512.0,
            layerMask
        );

        let finalDistance = Infinity;
        let finalRay = null;
        for (const hit of hits) {
            const distance = Vector3.method("Distance").invoke(hit.method("get_point").invoke(), StartPosition);
            if (distance < finalDistance) {
                finalRay = hit;
                finalDistance = distance;
            }
        }

        let EndPosition;
        if (gunLocked) {
            EndPosition = getTransform(lockTarget).method("get_position").invoke();
        } else {
            EndPosition = finalRay.method("get_point").invoke();
        }

        if (Vector3.method("op_Equality").invoke(EndPosition, zeroVector)) {
            const farDirection = Vector3.method("op_Multiply").invoke(Direction, 512);
            EndPosition = Vector3.method("op_Addition").invoke(StartPosition, farDirection);
        }

        if (GunPointer == null) {
            GunPointer = createObject(EndPosition, identityQuaternion, [0.1, 0.1, 0.1], 0, [1, 1, 1, 1]);
        }

        GunPointer.method("SetActive").invoke(true);
        const pointerTransform = getTransform(GunPointer);
        pointerTransform.method("set_position").invoke(EndPosition);

        const PointerRenderer = getComponent(GunPointer, Renderer);
        const material = PointerRenderer.method("get_material").invoke();

        material.method("set_shader").invoke(TextShader);

        const pointerColor = (gunLocked || rightTrigger) ? buttonPressedColor : buttonColor;
        material.method("set_color").invoke(pointerColor);

        const collider = getComponent(GunPointer, Collider);
        if (collider != null) {
            Destroy(collider);
        }

        if (GunLine == null) {
            const lineObj = createObject(zeroVector, identityQuaternion, oneVector, 0, [0, 0, 0, 0]);
            GunLine = addComponent(lineObj, LineRenderer);
        } else {
            GunLine.method("get_gameObject").invoke().method("SetActive").invoke(true);
        }

        const lineMaterial = GunLine.method("get_material").invoke();
        lineMaterial.method("set_shader").invoke(TextShader);

        GunLine.method("set_startColor").invoke(bgColor);
        GunLine.method("set_endColor").invoke(bgColor);

        const lineWidth = 0.025;
        GunLine.method("set_startWidth").invoke(lineWidth);
        GunLine.method("set_endWidth").invoke(lineWidth);

        GunLine.method("set_positionCount").invoke(2);
        GunLine.method("set_useWorldSpace").invoke(true);

        GunLine.method("set_numCapVertices").invoke(10);

        GunLine.method("SetPosition").invoke(0, StartPosition);
        GunLine.method("SetPosition").invoke(1, EndPosition);

        if (rightTrigger || gunLocked) {
            const Step = 10;
            GunLine.method("set_positionCount").invoke(Step);
            GunLine.method("SetPosition").invoke(0, StartPosition);

            for (let i = 1; i < (Step - 1); i++) {
                const t = i / (Step - 1);
                const Position = Vector3.method("Lerp").invoke(StartPosition, EndPosition, t);

                const randomValue = Math.random();
                let offset = zeroVector;

                if (randomValue > 0.75) {
                    offset = [
                        (Math.random() * 0.2) - 0.1,
                        (Math.random() * 0.2) - 0.1,
                        (Math.random() * 0.2) - 0.1
                    ];
                }

                const finalPosition = Vector3.method("op_Addition").invoke(Position, offset);
                GunLine.method("SetPosition").invoke(i, finalPosition);
            }

            GunLine.method("SetPosition").invoke(Step - 1, EndPosition);
        }

        return { ray: finalRay, gunPointer: GunPointer };
    }

    function recenterMenu() {
        const menuTransform = getTransform(menu);
        let targetPos, targetRot;

        if (righthand) {
            targetPos = rightHandTransform.method("get_position").invoke();
            targetRot = rightHandTransform.method("get_rotation").invoke();
            targetRot = Quaternion.method("op_Multiply").invoke(targetRot, Quaternion.method("Euler").invoke(0, 0, 180));
        } else {
            targetPos = leftHandTransform.method("get_position").invoke();
            targetRot = leftHandTransform.method("get_rotation").invoke();
            targetRot = Quaternion.method("op_Multiply").invoke(targetRot, Quaternion.method("Euler").invoke(0, 0, 0));
        }

        if (LerpMenu) {
            const menuPos = menuTransform.method("get_position").invoke();
            const distance = Vector3.method("Distance").invoke(menuPos, zeroVector);
            if (distance < 1) {
                menuTransform.method("set_position").invoke(targetPos);
                menuTransform.method("set_rotation").invoke(targetRot);
            } else {
                const newPos = Vector3.method("Lerp").invoke(menuPos, targetPos, deltaTime * 15);
                menuTransform.method("set_position").invoke(newPos);
                const newRot = Quaternion.method("Slerp").invoke(menuTransform.method("get_rotation").invoke(), targetRot, deltaTime * 15);
                menuTransform.method("set_rotation").invoke(newRot);
            }
        } else {
            menuTransform.method("set_position").invoke(targetPos);
            menuTransform.method("set_rotation").invoke(targetRot);
        }
    }

    function reloadMenu() {
        if (menu != null) {
            Object.method("Destroy", 1).invoke(menu);
            menu = null;
        }
    }

    function updateButtonColor(button, buttonData) {
        const RendererClass = Il2Cpp.domain
            .assembly("UnityEngine.CoreModule")
            .image
            .class("UnityEngine.Renderer");

        const renderer = getComponent(button, RendererClass);
        if (!renderer) {
            return;
        }

        const material = renderer.method("get_material").invoke();
        material.method("set_color").invoke(buttonData.enabled ? buttonPressedColor : buttonColor);
    }

    function playButtonSound() {
        LocalRig.method("PlayHandTapLocal").invoke(buttonSound, false, 0.3);
        if (righthand) {
            GorillaTagger.method("StartVibration").invoke(true, 0.5, 0.075);
        }
        else {
            GorillaTagger.method("StartVibration").invoke(false, 0.5, 0.075);
        }
    }

    let lastSoundRpc: number = -10.0;

    function playSoundId(soundId: number, localOnly: boolean = false) {
        try {
            LocalRig.method("PlayHandTapLocal").invoke(soundId, false, 999999.0);
        } catch (e) { }
        if (localOnly) return;
        try {
            if (time - lastSoundRpc < 0.05) return;
            lastSoundRpc = time;
            const objectArray = Il2Cpp.array(SystemObject, [
                Il2Cpp.reference(soundId, Il2Cpp.Type.Enum.INT),
                Il2Cpp.reference(false, Il2Cpp.Type.Enum.BOOLEAN),
                Il2Cpp.reference(999999.0, Il2Cpp.Type.Enum.FLOAT)
            ]);
            const rpcMethod = GorillaTagger.method("get_myVRRig").invoke().method("SendRPC", 3).overload(
                "System.String",
                "Photon.Pun.RpcTarget",
                "System.Object[]");
            rpcMethod.invoke(Il2Cpp.string("RPC_PlayHandTap"), 0, objectArray);
        } catch (e) { }
    }

    let vrMediaPlayer: any = null;
    let vrCurrentTrack: string = "";

    function stopMp3VR() {
        try {
            if (vrMediaPlayer != null) {
                const mp = vrMediaPlayer;
                vrMediaPlayer = null;
                try { mp.stop(); } catch (e) { }
                try { mp.release(); } catch (e) { }
            }
        } catch (e) { }
        vrCurrentTrack = "";
    }

    function playMp3VR(fileName: string) {
        stopMp3VR();
        vrCurrentTrack = fileName;
        const tryPaths = [
            "/sdcard/SoundBoard/" + fileName,
            "/sdcard/Android/data/com.anotheraxiom.gorillatag/files/SoundBoard/" + fileName,
            "/data/local/tmp/SoundBoard/" + fileName
        ];
        sendNotification("Playing: " + fileName);
        try {
            if (typeof Java !== "undefined" && Java.available) {
                Java.perform(() => {
                    try {
                        const MediaPlayer = Java.use("android.media.MediaPlayer");
                        let lastErr: any = null;
                        for (const p of tryPaths) {
                            try {
                                const mp = MediaPlayer.$new();
                                mp.setDataSource(p);
                                mp.setVolume(1.0, 1.0);
                                mp.prepare();
                                mp.start();
                                vrMediaPlayer = mp;
                                return;
                            } catch (e) {
                                lastErr = e;
                                console.error("playMp3VR try " + p + " failed:", e);
                            }
                        }
                        sendNotification("EACCES: give Gorilla Tag storage perm, see console");
                        console.error("playMp3VR all paths failed, last:", lastErr);
                    } catch (e) {
                        console.error("playMp3VR Java error:", e);
                        sendNotification("No file: " + tryPaths[0]);
                    }
                });
                return;
            }
        } catch (e) {
            console.error("playMp3VR error:", e);
        }
        sendNotification("Push mp3 to " + tryPaths[0]);
    }

    let vrPhotonRequest: any = null;
    let vrPhotonReqStart: number = 0;
    let vrOnlyMe: boolean = false;
    let vrPhotonGO: any = null;
    let vrMonitorGO: any = null;

    const gripSounds: number[] = [
        153,
        10, 336, 337, 11, 12, 13, 48, 50, 154, 155, 156, 157,
        75, 76, 77, 78, 84, 89, 64, 24, 18,
        40, 41, 214, 215, 216, 110, 111, 112, 113, 120, 121,
        7, 130, 131, 132, 133, 134,
        0, 1, 2, 3, 4, 5, 6, 20, 30, 55, 56, 57,
        201, 202, 203, 204, 205, 206, 207, 208, 209, 210,
        211, 212, 213, 217, 218, 219, 220, 221, 222, 223,
        224, 225, 226, 227, 228, 229, 230, 231, 232, 233,
        234, 235, 236, 237, 238, 239, 240, 241, 242, 243,
        244, 245, 246, 247, 248, 249, 250, 251, 252, 253
    ];
    const gripSpamNames: string[] = ["Normal", "5/s", "10/s", "15/s", "20/s", "25/s", "50/s", "100/s"];
    const gripSpamIntervals: number[] = [0, 0.2, 0.1, 0.0667, 0.05, 0.04, 0.02, 0.01];
    let gripSoundEnabled: boolean = false;
    let gripSoundIndex: number = 0;
    let gripSpamMode: number = 0;
    let gripWasLeft: boolean = false;
    let gripWasRight: boolean = false;
    let gripNextTime: number = 0;

    function gripSoundUpdate() {
        const id = gripSounds[gripSoundIndex % gripSounds.length];
        const flood = gripSpamMode >= 6;
        if (gripSpamMode > 0) {
            const interval = gripSpamIntervals[gripSpamMode];
            if ((leftGrab || rightGrab) && time >= gripNextTime) {
                gripNextTime = time + interval;
                playSoundId(id, flood);
            }
        } else {
            if (leftGrab && !gripWasLeft) playSoundId(id);
            if (rightGrab && !gripWasRight) playSoundId(id);
        }
        gripWasLeft = leftGrab;
        gripWasRight = rightGrab;
    }

    function gripNextSound() {
        gripSoundIndex = (gripSoundIndex + 1) % gripSounds.length;
        playSoundId(gripSounds[gripSoundIndex]);
        sendNotification("Grip Sound ID: " + gripSounds[gripSoundIndex]);
    }

    function gripPrevSound() {
        gripSoundIndex = (gripSoundIndex - 1 + gripSounds.length) % gripSounds.length;
        playSoundId(gripSounds[gripSoundIndex]);
        sendNotification("Grip Sound ID: " + gripSounds[gripSoundIndex]);
    }

    function gripCycleSpam() {
        gripSpamMode = (gripSpamMode + 1) % gripSpamNames.length;
        sendNotification("Grip Spam [" + gripSpamNames[gripSpamMode] + "] ID: " + gripSounds[gripSoundIndex]);
    }

    function destroyMonitorVR() {
        try {
            if (vrMonitorGO != null) { Destroy(vrMonitorGO); vrMonitorGO = null; }
        } catch (e) { }
    }

    function playMonitorVR(clip: any, label: string) {
        try {
            const AudioSource = resolveClassVR(["UnityEngine.AudioModule", "UnityEngine.CoreModule", "UnityEngine"], "UnityEngine.AudioSource");
            if (AudioSource == null) { console.error("playMonitorVR: AudioSource N/A"); return; }
            destroyMonitorVR();
            vrMonitorGO = createObject(zeroVector, identityQuaternion, oneVector, 3, [0, 0, 0, 0]);
            Destroy(getComponent(vrMonitorGO, BoxCollider));
            const src = addComponent(vrMonitorGO, AudioSource);
            src.method("set_spatialBlend").invoke(0.0);
            src.method("set_volume").invoke(0.7);
            src.method("set_loop").invoke(false);
            src.method("set_clip").invoke(clip);
            src.method("Play").invoke();
            console.log("playMonitorVR: local monitor ON for " + label);
        } catch (e) {
            console.error("playMonitorVR error:", e);
        }
    }

    function getRecorderVR(): any {
        const cands: string[] = ["myRecorder", "<myRecorder>k__BackingField", "_myRecorder", "recorder", "<recorder>k__BackingField"];
        for (const name of cands) {
            try {
                const r = GorillaTagger.field(name).value;
                if (r != null && r.handle != null && !r.handle.isNull()) { console.log("getRecorderVR: found via field " + name); return r; }
            } catch (e) { }
        }
        try {
            const r = GorillaTagger.method("get_myRecorder").invoke();
            if (r != null && r.handle != null && !r.handle.isNull()) { console.log("getRecorderVR: found via get_myRecorder"); return r; }
        } catch (e) { console.error("getRecorderVR get_myRecorder fail:", e); }
        console.error("getRecorderVR: NOT FOUND (tried " + cands.join(",") + ")");
        return null;
    }

    function setRecVR(rec: any, prop: string, val: any): boolean {
        const fieldNames = [prop, "<" + prop + ">k__BackingField", "_" + prop.charAt(0).toLowerCase() + prop.slice(1)];
        for (const fn of fieldNames) {
            try {
                rec.field(fn).value = val;
                console.log("setRecVR: field " + fn + " = " + val + " OK");
                return true;
            } catch (e) { }
        }
        if (val === null || val === undefined) {
            console.log("setRecVR: skip null " + prop + " (no field, non-fatal)");
            return true;
        }
        try {
            rec.method("set_" + prop).invoke(val);
            console.log("setRecVR: set_" + prop + "(" + val + ") OK");
            return true;
        } catch (e) {
            console.error("setRecVR FAIL " + prop + ":", e);
        }
        return false;
    }

    const vrClassCache: any = {};

    function resolveClassVR(assemblyNames: string[], className: string): any {
        if (vrClassCache[className] !== undefined) return vrClassCache[className];
        for (const asm of assemblyNames) {
            try {
                const c = Il2Cpp.domain.tryAssembly(asm)?.image?.class(className);
                if (c != null) { console.log("resolveClassVR: " + className + " in " + asm); vrClassCache[className] = c; return c; }
            } catch (e) { }
        }
        try {
            const all = Il2Cpp.domain.assemblies;
            for (const asm of all) {
                try {
                    const c = asm.image.class(className);
                    if (c != null) {
                        let an = "?";
                        try { an = asm.name; } catch (e) { }
                        console.log("resolveClassVR: " + className + " FOUND in [" + an + "]");
                        vrClassCache[className] = c;
                        return c;
                    }
                } catch (e) { }
            }
        } catch (e) { console.error("resolveClassVR scan fail:", e); }
        console.error("resolveClassVR: " + className + " NOT FOUND anywhere");
        vrClassCache[className] = null;
        return null;
    }

    function fixMicVR() {
        destroyMonitorVR();
        try {
            const rec = getRecorderVR();
            if (rec != null) {
                setRecVR(rec, "SourceType", 1);
                setRecVR(rec, "AudioClip", null);
                setRecVR(rec, "DebugEchoMode", false);
                try { rec.method("RestartRecording").invoke(true); console.log("fixMicVR: RestartRecording OK"); } catch (e) { console.error("fixMicVR RestartRecording fail:", e); }
            }
        } catch (e) { }
        try {
            if (vrPhotonGO != null) { Destroy(vrPhotonGO); vrPhotonGO = null; }
        } catch (e) { }
        vrPhotonRequest = null;
        sendNotification("Mic fixed");
    }

    function stopPhotonVR() {
        stopMp3VR();
        destroyMonitorVR();
        try {
            const rec = getRecorderVR();
            if (rec != null) {
                setRecVR(rec, "SourceType", 1);
                setRecVR(rec, "AudioClip", null);
                setRecVR(rec, "DebugEchoMode", false);
                try { rec.method("RestartRecording").invoke(true); console.log("stopPhotonVR: RestartRecording OK"); } catch (e) { console.error("stopPhotonVR RestartRecording fail:", e); }
            }
        } catch (e) { }
        try {
            if (vrPhotonGO != null) { Destroy(vrPhotonGO); vrPhotonGO = null; }
        } catch (e) { }
        vrPhotonRequest = null;
        sendNotification("Stopped");
    }

    function readFileBytesVR(path: string): number[] | null {
        try {
            const FileInputStream = Java.use("java.io.FileInputStream");
            const fis = FileInputStream.$new(path);
            const out: number[] = [];
            const chunk = 65536;
            const buf = Java.array("byte", new Array(chunk).fill(0));
            while (true) {
                const n = fis.read(buf);
                if (n <= 0) break;
                for (let i = 0; i < n; i++) {
                    let b = buf[i];
                    out.push(b < 0 ? b + 256 : b);
                }
                if (out.length > 12 * 1024 * 1024) { console.error("readFileBytesVR: file too big"); break; }
            }
            try { fis.close(); } catch (e) { }
            return out;
        } catch (e) {
            console.error("readFileBytesVR fail " + path + ":", e);
            return null;
        }
    }

    function parseWavPCM(bytes: number[]): any {
        try {
            const str = (o: number, n: number) => String.fromCharCode(...bytes.slice(o, o + n));
            if (str(0, 4) != "RIFF" || str(8, 4) != "WAVE") { console.error("parseWavPCM: not RIFF/WAVE"); return null; }
            let pos = 12;
            let fmt: any = null;
            let data: number[] = [];
            while (pos + 8 <= bytes.length) {
                const id = str(pos, 4);
                const sz = bytes[pos + 4] | (bytes[pos + 5] << 8) | (bytes[pos + 6] << 16) | (bytes[pos + 7] << 24);
                if (id == "fmt ") {
                    fmt = {
                        format: bytes[pos + 8] | (bytes[pos + 9] << 8),
                        channels: bytes[pos + 10] | (bytes[pos + 11] << 8),
                        rate: bytes[pos + 12] | (bytes[pos + 13] << 8) | (bytes[pos + 14] << 16) | (bytes[pos + 15] << 24),
                        bits: bytes[pos + 22] | (bytes[pos + 23] << 8)
                    };
                } else if (id == "data") {
                    data = bytes.slice(pos + 8, pos + 8 + sz);
                }
                pos += 8 + sz;
            }
            if (fmt == null) { console.error("parseWavPCM: no fmt"); return null; }
            if (fmt.format != 1) { console.error("parseWavPCM: not PCM, format=" + fmt.format); sendNotification("WAV must be PCM"); return null; }
            if (data.length == 0) { console.error("parseWavPCM: no data"); return null; }
            const floats: number[] = [];
            if (fmt.bits == 16) {
                for (let i = 0; i + 1 < data.length; i += 2) {
                    let s = data[i] | (data[i + 1] << 8);
                    if (s >= 32768) s -= 65536;
                    floats.push(s / 32768);
                }
            } else if (fmt.bits == 8) {
                for (let i = 0; i < data.length; i++) floats.push((data[i] - 128) / 128);
            } else { console.error("parseWavPCM: bits=" + fmt.bits + " unsupported"); sendNotification("WAV must be 8/16-bit"); return null; }
            const frames = Math.floor(floats.length / fmt.channels);
            return { floats, frames, channels: fmt.channels, rate: fmt.rate };
        } catch (e) {
            console.error("parseWavPCM error:", e);
            return null;
        }
    }

    function findMp3PathVR(fileName: string): string {
        const fallback = "/sdcard/Android/data/com.anotheraxiom.gorillatag/files/SoundBoard/" + fileName;
        try {
            if (typeof Java !== "undefined" && Java.available) {
                const File = Java.use("java.io.File");
                const cands = [
                    "/sdcard/Android/data/com.anotheraxiom.gorillatag/files/SoundBoard/" + fileName,
                    "/data/local/tmp/SoundBoard/" + fileName,
                    "/sdcard/SoundBoard/" + fileName
                ];
                for (const p of cands) {
                    try { if (File.$new(p).exists()) { console.log("findMp3PathVR: using " + p); return p; } } catch (e) { }
                }
            }
        } catch (e) { }
        return fallback;
    }

    function decodeMp3ToPCMVR(path: string): any {
        try {
            const MediaExtractor = Java.use("android.media.MediaExtractor");
            const MediaCodec = Java.use("android.media.MediaCodec");
            const ext = MediaExtractor.$new();
            ext.setDataSource(path);
            const nTracks = ext.getTrackCount();
            let track = -1;
            let mime = "";
            for (let i = 0; i < nTracks; i++) {
                try {
                    const fmt = ext.getTrackFormat(i);
                    const m = fmt.getString("mime");
                    if (m.indexOf("audio/") == 0) { track = i; mime = m; break; }
                } catch (e) { }
            }
            if (track < 0) { console.error("decodeMp3: no audio track"); return null; }
            console.log("decodeMp3: track=" + track + " mime=" + mime);
            ext.selectTrack(track);
            const codec = MediaCodec.createDecoderByType(mime);
            const fmt0 = ext.getTrackFormat(track);
            codec.configure(fmt0, null, null, 0);
            codec.start();
            const pcm: number[] = [];
            let rate = 44100;
            let ch = 2;
            let sawInputEOS = false;
            let sawOutputEOS = false;
            let iter = 0;
            const maxBytes = 35 * 48000 * 2 * 2;
            while (!sawOutputEOS && iter < 20000 && pcm.length < maxBytes) {
                iter++;
                if (!sawInputEOS) {
                    const inIdx = codec.dequeueInputBuffer(10000);
                    if (inIdx >= 0) {
                        const inBufs = codec.getInputBuffers();
                        const buf = inBufs[inIdx];
                        buf.clear();
                        const sz = ext.readSampleData(buf, 0);
                        if (sz < 0) {
                            codec.queueInputBuffer(inIdx, 0, 0, 0, 4);
                            sawInputEOS = true;
                        } else {
                            const t = ext.getSampleTime();
                            codec.queueInputBuffer(inIdx, 0, sz, t, 0);
                            ext.advance();
                        }
                    }
                }
                const Info = Java.use("android.media.MediaCodec$BufferInfo");
                const info = Info.$new();
                const outIdx = codec.dequeueOutputBuffer(info, 10000);
                const flags = info.flags.value;
                const size = info.size.value;
                const off = info.offset.value;
                if (outIdx == -2) {
                    try {
                        const of = codec.getOutputFormat();
                        rate = of.getInteger("sample-rate");
                        ch = of.getInteger("channel-count");
                        console.log("decodeMp3: out format rate=" + rate + " ch=" + ch);
                    } catch (e) { console.error("decodeMp3: getOutputFormat fail:", e); }
                } else if (outIdx >= 0) {
                    if (size > 0) {
                        try {
                            const ob = codec.getOutputBuffer(outIdx);
                            const arr = Java.array("byte", new Array(size).fill(0));
                            ob.position(off);
                            ob.get(arr, 0, size);
                            for (let i = 0; i < size; i++) {
                                let b = arr[i];
                                pcm.push(b < 0 ? b + 256 : b);
                            }
                        } catch (e) { console.error("decodeMp3: read out buf fail:", e); }
                    }
                    try { codec.releaseOutputBuffer(outIdx, false); } catch (e) { }
                    if ((flags & 4) != 0) sawOutputEOS = true;
                }
            }
            try { codec.stop(); } catch (e) { }
            try { codec.release(); } catch (e) { }
            try { ext.release(); } catch (e) { }
            console.log("decodeMp3: done bytes=" + pcm.length + " rate=" + rate + " ch=" + ch + " iter=" + iter);
            if (pcm.length == 0) return null;
            const floats: number[] = [];
            for (let i = 0; i + 1 < pcm.length; i += 2) {
                let s = pcm[i] | (pcm[i + 1] << 8);
                if (s >= 32768) s -= 65536;
                floats.push(s / 32768);
            }
            let mono = floats;
            if (ch == 2) {
                mono = [];
                for (let i = 0; i + 1 < floats.length; i += 2) mono.push((floats[i] + floats[i + 1]) / 2);
                ch = 1;
            }
            const maxFrames = rate * 30;
            let frames = Math.floor(mono.length / ch);
            if (frames > maxFrames) {
                mono = mono.slice(0, maxFrames * ch);
                frames = maxFrames;
                sendNotification("Trimmed to 30s");
            }
            return { floats: mono, frames, channels: ch, rate };
        } catch (e) {
            console.error("decodeMp3 error:", e);
            return null;
        }
    }

    const vrClipCache: any = {};

    function cachedClipVR(label: string): any {
        try {
            const c = vrClipCache[label];
            if (c != null && c.handle != null && !c.handle.isNull()) return c;
        } catch (e) { }
        return null;
    }

    function routeClipVR(clip: any, label: string) {
        if (vrOnlyMe) {
            const AudioSource = resolveClassVR(["UnityEngine.AudioModule", "UnityEngine.CoreModule", "UnityEngine"], "UnityEngine.AudioSource");
            if (AudioSource == null) { sendNotification("AudioSource N/A"); return; }
            try { if (vrPhotonGO != null) Destroy(vrPhotonGO); } catch (e) { }
            vrPhotonGO = createObject(zeroVector, identityQuaternion, oneVector, 3, [0, 0, 0, 0]);
            Destroy(getComponent(vrPhotonGO, BoxCollider));
            const src = addComponent(vrPhotonGO, AudioSource);
            src.method("set_spatialBlend").invoke(0.0);
            src.method("set_clip").invoke(clip);
            src.method("Play").invoke();
            sendNotification("Playing (only me): " + label);
        } else {
            const rec = getRecorderVR();
            if (rec == null) { sendNotification("Recorder N/A"); return; }
            const okST = setRecVR(rec, "SourceType", 2);
            const okClip = setRecVR(rec, "AudioClip", clip);
            setRecVR(rec, "DebugEchoMode", true);
            try { rec.method("RestartRecording").invoke(true); console.log("routeClipVR: RestartRecording OK"); } catch (e) { console.error("RestartRecording fail:", e); }
            if (!okST || !okClip) sendNotification("Recorder set FAILED, see console");
            else {
                playMonitorVR(clip, label);
                sendNotification("Playing (all+you): " + label);
            }
        }
    }

    function pcmToPhotonVR(pcm: any, label: string) {
        const AudioClip = resolveClassVR(["UnityEngine.AudioModule", "UnityEngine.CoreModule", "UnityEngine"], "UnityEngine.AudioClip");
        if (AudioClip == null) { sendNotification("AudioClip N/A"); return; }
        console.log("pcmToPhotonVR: frames=" + pcm.frames + " ch=" + pcm.channels + " rate=" + pcm.rate);
        const clip = AudioClip.method("Create", 5).invoke(Il2Cpp.string("sb_" + label), pcm.frames, pcm.channels, pcm.rate, false);
        if (clip == null || clip.handle.isNull()) { sendNotification("Clip create fail"); return; }
        const Single = Il2Cpp.corlib.class("System.Single");
        const step = 8192 * pcm.channels;
        let wrote = 0;
        for (let off = 0; off < pcm.floats.length; off += step) {
            const part = pcm.floats.slice(off, off + step);
            const arr = Il2Cpp.array(Single, part);
            const ok = clip.method("SetData").invoke(arr, Math.floor(off / pcm.channels));
            if (!ok) { console.error("pcmToPhotonVR: SetData chunk fail at " + off); sendNotification("SetData fail"); return; }
            wrote++;
        }
        console.log("pcmToPhotonVR: SetData chunks=" + wrote);
        vrClipCache[label] = clip;
        routeClipVR(clip, label);
    }

    function playMp3PhotonVR(fileName: string) {
        stopPhotonVR();
        const hit = cachedClipVR(fileName);
        if (hit != null) {
            console.log("playMp3PhotonVR: cache HIT " + fileName);
            sendNotification("Cached: " + fileName);
            routeClipVR(hit, fileName);
            return;
        }
        sendNotification("Decoding MP3: " + fileName);
        
        // Run decode in separate thread to prevent freeze
        try {
            Java.perform(() => {
                try {
                    const Thread = Java.use("java.lang.Thread");
                    const runnable = Java.use("java.lang.Runnable");
                    
                    const decodeTask = Java.extend(runnable, {
                        run: () => {
                            try {
                                console.log("playMp3PhotonVR: decode thread START for " + fileName);
                                const path = findMp3PathVR(fileName);
                                console.log("playMp3PhotonVR: found path " + path);
                                const pcm = decodeMp3ToPCMVR(path);
                                
                                if (pcm == null) { 
                                    console.error("playMp3PhotonVR: pcm is null");
                                    sendNotification("MP3 decode fail");
                                    return; 
                                }
                                
                                console.log("playMp3PhotonVR: decode SUCCESS, routing...");
                                pcmToPhotonVR(pcm, fileName);
                            } catch (e) {
                                console.error("playMp3PhotonVR thread error:", e);
                                sendNotification("MP3 error: " + e);
                            }
                        }
                    });
                    
                    const thread = Thread.$new(decodeTask);
                    thread.start();
                    console.log("playMp3PhotonVR: thread started");
                } catch (e) {
                    console.error("playMp3PhotonVR thread creation error:", e);
                    sendNotification("Thread error");
                }
            });
        } catch (e) {
            console.error("playMp3PhotonVR Java perform error:", e);
            sendNotification("MP3 photon error");
        }
    }

    function findWavPathVR(fileName: string): string {
        try {
            if (typeof Java !== "undefined" && Java.available) {
                const File = Java.use("java.io.File");
                const cands = [
                    "/sdcard/Android/data/com.anotheraxiom.gorillatag/files/SoundBoard/" + fileName,
                    "/data/local/tmp/SoundBoard/" + fileName,
                    "/sdcard/SoundBoard/" + fileName
                ];
                for (const p of cands) {
                    try { if (File.$new(p).exists()) return p; } catch (e) { }
                }
            }
        } catch (e) { }
        return "/sdcard/Android/data/com.anotheraxiom.gorillatag/files/SoundBoard/" + fileName;
    }

    function playWavPhotonVR(fileName: string) {
        stopPhotonVR();
        const hit = cachedClipVR(fileName);
        if (hit != null) {
            console.log("playWavPhotonVR: cache HIT " + fileName);
            sendNotification("Cached: " + fileName);
            routeClipVR(hit, fileName);
            return;
        }
        sendNotification("Loading WAV: " + fileName);
        try {
            const path = findWavPathVR(fileName);
            try {
                if (typeof Java !== "undefined" && Java.available) {
                    const File = Java.use("java.io.File");
                    const len = File.$new(path).length();
                    console.log("playWavPhotonVR: file bytes=" + len);
                    if (len > 6 * 1024 * 1024) { sendNotification("Too big, reconvert mono 16kHz"); return; }
                }
            } catch (e) { }
            const bytes = readFileBytesVR(path);
            if (bytes == null) { sendNotification("No file, push " + fileName); return; }
            const wav = parseWavPCM(bytes);
            if (wav == null) return;
            const maxFrames = wav.rate * 30;
            if (wav.frames > maxFrames) {
                wav.floats = wav.floats.slice(0, maxFrames * wav.channels);
                wav.frames = maxFrames;
                sendNotification("Trimmed to 30s");
            }
            const AudioClip = resolveClassVR(["UnityEngine.AudioModule", "UnityEngine.CoreModule", "UnityEngine"], "UnityEngine.AudioClip");
            if (AudioClip == null) { sendNotification("AudioClip N/A"); return; }
            console.log("playWavPhotonVR: frames=" + wav.frames + " ch=" + wav.channels + " rate=" + wav.rate);
            const clip = AudioClip.method("Create", 5).invoke(Il2Cpp.string("sb_" + fileName), wav.frames, wav.channels, wav.rate, false);
            if (clip == null || clip.handle.isNull()) { sendNotification("Clip create fail"); return; }
            const Single = Il2Cpp.corlib.class("System.Single");
            const step = 8192 * wav.channels;
            let wrote = 0;
            for (let off = 0; off < wav.floats.length; off += step) {
                const part = wav.floats.slice(off, off + step);
                const arr = Il2Cpp.array(Single, part);
                const ok = clip.method("SetData").invoke(arr, Math.floor(off / wav.channels));
                if (!ok) { console.error("playWavPhotonVR: SetData chunk fail at " + off); sendNotification("SetData fail"); return; }
                wrote++;
            }
            console.log("playWavPhotonVR: SetData chunks=" + wrote);
            vrClipCache[fileName] = clip;
            routeClipVR(clip, fileName);
        } catch (e) {
            console.error("playWavPhotonVR error:", e);
            sendNotification("WAV photon error");
        }
    }

    function toggleColliders(enabled) {
        const meshColliders = Object.method("FindObjectsOfType").inflate(MeshCollider).invoke();

        for (let i = 0; i < meshColliders.length; i++) {
            const meshCollider = meshColliders.get(i);
            meshCollider.method("set_enabled").invoke(enabled);
        }
    }

    interface ButtonInfoConfig {
        buttonText: string;
        method?: () => void;
        enableMethod?: () => void;
        disableMethod?: () => void;
        isTogglable?: boolean;
        toolTip?: string;
        enabled?: boolean;
    }

    class ButtonInfo {
        buttonText: string;
        method?: () => void;
        enableMethod?: () => void;
        disableMethod?: () => void;
        isTogglable: boolean;
        toolTip?: string;
        enabled: boolean;

        constructor(config: ButtonInfoConfig) {
            this.buttonText = config.buttonText;
            this.method = config.method;
            this.enableMethod = config.enableMethod;
            this.disableMethod = config.disableMethod;
            this.isTogglable = config.isTogglable ?? true;
            this.toolTip = config.toolTip ?? null;
            this.enabled = config.enabled ?? false;
        }
    }

    let currentCategory = 0;
    let currentPage = 0;

    function getSoundboardButtonsVR(): any[] {
        const soundButtons: any[] = [];
        
        // Основные кнопки
        soundButtons.push(
            new ButtonInfo({
                buttonText: "Exit Soundboard",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
            new ButtonInfo({ buttonText: "Stop", method: () => stopPhotonVR(), isTogglable: false, toolTip: "Stop sound + restore mic." }),
            new ButtonInfo({ buttonText: "Fix Mic", method: () => fixMicVR(), isTogglable: false, toolTip: "Restore headset mic." }),
            new ButtonInfo({ buttonText: "Only Me OFF", method: () => { vrOnlyMe = !vrOnlyMe; sendNotification(vrOnlyMe ? "Only Me: ON" : "Only Me: OFF"); reloadMenu(); }, isTogglable: false, toolTip: "ON = only you hear. OFF = all players hear via Photon." })
        );
        
        // Сканирование папок со звуками
        const soundPaths = [
            "/sdcard/SoundBoard/",
            "/sdcard/Android/data/com.anotheraxiom.gorillatag/files/SoundBoard/",
            "/data/local/tmp/SoundBoard/"
        ];
        
        const foundSounds: Set<string> = new Set();
        
        try {
            Java.perform(() => {
                const File = Java.use("java.io.File");
                
                for (const basePath of soundPaths) {
                    try {
                        const folder = File.$new(basePath);
                        if (!folder.exists() || !folder.isDirectory()) {
                            console.log("❌ SoundBoard path not found: " + basePath);
                            continue;
                        }
                        
                        console.log("✅ Scanning: " + basePath);
                        const files = folder.listFiles();
                        
                        if (files != null) {
                            for (let i = 0; i < files.length; i++) {
                                const file = files[i];
                                try {
                                    const fileName = file.getName().toString();
                                    const isFile = file.isFile();
                                    const isMP3 = fileName.endsWith(".mp3") || fileName.endsWith(".MP3");
                                    const isWAV = fileName.endsWith(".wav") || fileName.endsWith(".WAV");
                                    
                                    if (isFile && (isMP3 || isWAV)) {
                                        if (!foundSounds.has(fileName)) {
                                            foundSounds.add(fileName);
                                            console.log("🔊 Found sound: " + fileName);
                                            
                                            // Создать кнопку для этого файла
                                            const buttonName = fileName.replace(/\.[^.]+$/, ''); // Убрать расширение
                                            const isMP3File = isMP3;
                                            
                                            const playFunc = isMP3File ? 
                                                (() => playMp3PhotonVR(fileName)) : 
                                                (() => playWavPhotonVR(fileName));
                                            
                                            soundButtons.push(
                                                new ButtonInfo({
                                                    buttonText: buttonName,
                                                    method: playFunc,
                                                    isTogglable: false,
                                                    toolTip: "Play: " + fileName
                                                })
                                            );
                                        }
                                    }
                                } catch (e) {
                                    console.error("Error scanning file:", e);
                                }
                            }
                        }
                    } catch (e) {
                        console.error("Error scanning path " + basePath + ":", e);
                    }
                }
            });
        } catch (e) {
            console.error("getSoundboardButtonsVR error:", e);
        }
        
        const totalSounds = foundSounds.size;
        console.log("🎵 Total sounds found: " + totalSounds);
        
        if (totalSounds == 0) {
            soundButtons.push(
                new ButtonInfo({
                    buttonText: "No sounds found",
                    method: () => sendNotification("Put MP3/WAV in /sdcard/SoundBoard/ or /data/local/tmp/SoundBoard/"),
                    isTogglable: false,
                    toolTip: "No sound files found in SoundBoard folders"
                })
            );
        }
        
        return soundButtons;
    }

    const buttons: ButtonInfo[][] = [
        [ // Main [0]
            new ButtonInfo({
                buttonText: "Settings",
                method: () => { currentCategory = 2; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the settings category."
            }),
            new ButtonInfo({
                buttonText: "Favorite Mods",
                method: () => { currentCategory = 11; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens your favorite mods."
            }),
            new ButtonInfo({
                buttonText: "Enabled Mods",
                method: () => { currentCategory = 12; currentPage = 0; loadEnabled() },
                isTogglable: false,
                toolTip: "Opens your enabled mods."
            }),
            new ButtonInfo({
                buttonText: "Movement Mods",
                method: () => { currentCategory = 3; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the movement category."
            }),
            new ButtonInfo({
                buttonText: "Fun Mods",
                method: () => { currentCategory = 4; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the fun category."
            }),
            new ButtonInfo({
                buttonText: "Advantage Mods",
                method: () => { currentCategory = 5; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the advantage category."
            }),
            new ButtonInfo({
                buttonText: "Rig Mods",
                method: () => { currentCategory = 6; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the rig category."
            }),
            new ButtonInfo({
                buttonText: "Misc Mods",
                method: () => { currentCategory = 7; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the misc category."
            }),
            new ButtonInfo({
                buttonText: "Visual Mods",
                method: () => { currentCategory = 8; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the visual category."
            }),
            new ButtonInfo({
                buttonText: "Overpowered Mods",
                method: () => { currentCategory = 9; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the op category."
            }),
            new ButtonInfo({
                buttonText: "Safety Mods",
                method: () => { currentCategory = 10; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the safety category."
            }),
            new ButtonInfo({
                buttonText: "Soundboard",
                method: () => { currentCategory = 13; currentPage = 0 },
                isTogglable: false,
                toolTip: "Opens the soundboard (Endercat sounds)."
            }),
        ],

        [ // Hidden [1]
            new ButtonInfo({
                buttonText: "Disconnect",
                method: () => NetworkSystem.method("ReturnToSinglePlayer").invoke(),
                isTogglable: false,
                toolTip: "Disconnects you from the room."
            }),
            new ButtonInfo({
                buttonText: "PreviousPage",
                method: () => {
                    const lastPage = Math.ceil(buttons[currentCategory].length / 8) - 1;

                    currentPage--;
                    if (currentPage < 0)
                        currentPage = lastPage;
                },
                isTogglable: false
            }),
            new ButtonInfo({
                buttonText: "NextPage",
                method: () => {
                    const lastPage = Math.ceil(buttons[currentCategory].length / 8) - 1;

                    currentPage++;
                    currentPage %= lastPage + 1;
                },
                isTogglable: false
            }),
            new ButtonInfo({
                buttonText: "GlobalReturn",
                method: () => {
                    currentCategory = 0;
                    currentPage = 0;
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            })
        ],

        [ // Settings [2]
            new ButtonInfo({
                buttonText: "Exit Settings",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
            new ButtonInfo({
                buttonText: "Change Menu Theme",
                method: () => {
                    themeIndex++;
                    themeIndex %= 11;

                    switch (themeIndex) {
                        case 0:
                            bgColor = [0.5, 0.0, 0.8, 1.0];
                            textColor = [0.9, 0.8, 1.0, 1.0];

                            buttonColor = [0.25, 0.0, 0.4, 1.0];
                            buttonPressedColor = [0.6, 0.2, 1.0, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 1:
                            bgColor = [1.0, 0.0, 0.0, 1.0];
                            textColor = [1.0, 1.0, 1.0, 1.0];

                            buttonColor = [0.0, 0.0, 0.0, 1.0];
                            buttonPressedColor = [1.0, 0.0, 0.0, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 2:
                            bgColor = [0.0, 1.0, 0.0, 1.0];
                            textColor = [1.0, 1.0, 1.0, 1.0];

                            buttonColor = [0.0, 0.0, 0.0, 1.0];
                            buttonPressedColor = [0.0, 1.0, 0.0, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 3:
                            bgColor = [0.0, 0.0, 1.0, 1.0];
                            textColor = [1.0, 1.0, 1.0, 1.0];

                            buttonColor = [0.0, 0.0, 0.0, 1.0];
                            buttonPressedColor = [0.0, 0.0, 1.0, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 4:
                            bgColor = [0.5, 0.0, 0.5, 1.0];
                            textColor = [1.0, 0.9, 1.0, 1.0];

                            buttonColor = [0.25, 0.0, 0.25, 1.0];
                            buttonPressedColor = [0.7, 0.0, 0.7, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 5:
                            bgColor = [0.0, 0.7, 0.7, 1.0];
                            textColor = [1.0, 0.2, 0.8, 1.0];

                            buttonColor = [0.0, 0.3, 0.3, 1.0];
                            buttonPressedColor = [1.0, 0.0, 0.7, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 6:
                            bgColor = [0.9, 0.7, 0.1, 1.0];
                            textColor = [0.0, 0.0, 0.0, 1.0];

                            buttonColor = [0.2, 0.2, 0.2, 1.0];
                            buttonPressedColor = [1.0, 0.84, 0.0, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 7:
                            bgColor = [0.7, 0.9, 1.0, 1.0];
                            textColor = [0.1, 0.2, 0.4, 1.0];

                            buttonColor = [0.5, 0.7, 0.9, 1.0];
                            buttonPressedColor = [0.2, 0.4, 0.8, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 8:
                            bgColor = [0.6, 0.0, 0.0, 1.0];
                            textColor = [1.0, 0.7, 0.2, 1.0];

                            buttonColor = [0.2, 0.0, 0.0, 1.0];
                            buttonPressedColor = [1.0, 0.3, 0.0, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 9:
                            bgColor = [0.05, 0.05, 0.1, 1.0];
                            textColor = [0.6, 0.8, 1.0, 1.0];

                            buttonColor = [0.1, 0.1, 0.2, 1.0];
                            buttonPressedColor = [0.4, 0.6, 1.0, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                        case 10:
                            bgColor = [0.125, 0.125, 0.125, 1.0];
                            textColor = [1.0, 1.0, 0.9, 1.0];

                            buttonColor = [0.111, 0.111, 0.222, 1.0];
                            buttonPressedColor = [0.111, 0.111, 0.67, 1.0];
                            boardMaterial.method("set_color").invoke(bgColor);
                            break;
                    }
                },
                isTogglable: false,
                toolTip: "Changes the theme of the menu."
            }),
            new ButtonInfo({
                buttonText: "Change Button Sound",
                method: () => {
                    buttonIndex++;
                    buttonIndex %= 5;

                    switch (buttonIndex) {
                        case 0:
                            buttonSound = 8;
                            break;
                        case 1:
                            buttonSound = 66;
                            break;
                        case 2:
                            buttonSound = 67;
                            break;
                        case 3:
                            buttonSound = 84;
                            break;
                        case 4:
                            buttonSound = 106;
                            break;
                        case 5:
                            buttonSound = 189;
                            break;
                    }
                },
                isTogglable: false,
                toolTip: "Changes the button sound."
            }),
            new ButtonInfo({
                buttonText: "Change Favorite Color",
                method: () => {
                    favoriteColor++;
                    favoriteColor %= 4;
                },
                isTogglable: false,
                toolTip: "Changes the text color of favorite mods."
            }),
            new ButtonInfo({
                buttonText: "Change Menu Scale",
                method: () => {
                    menuscale += 0.1;
                    if (menuscale > 1.5) {
                        menuscale = 0.3;
                    }
                },
                isTogglable: false,
                toolTip: "Changes the button sound."
            }),
            new ButtonInfo({
                buttonText: "Change Fly Speed",
                method: () => {
                    flySpeed += 5;
                    if (flySpeed > 100) {
                        flySpeed = 5;
                    }
                    sendNotification("Fly Speed: " + flySpeed);
                },
                isTogglable: false,
                toolTip: "Changes fly speed for Fly / Trigger Fly / Hand Fly. Current: 25"
            }),
            new ButtonInfo({
                buttonText: "Freeze Player in Menu",
                enabled: true,
                method: () => {
                    if (menu != null) {
                        if (closePosition == null) {
                            closePosition = getTransform(rigidbody).method("get_position").invoke();
                        }
                        else {
                            getTransform(rigidbody).method("set_position").invoke(closePosition);
                            rigidbody.method("set_velocity").invoke(zeroVector);
                        }
                    } else {
                        closePosition = null;
                    }
                },
                toolTip: "Freezes your character while in the menu."
            }),
            new ButtonInfo({
                buttonText: "Button Notifications",
                enabled: true,
                method: () => buttonNotifications = true,
                disableMethod: () => buttonNotifications = false,
                toolTip: "Shows notifications when clicking menu buttons, may cause lag."
            }),
            new ButtonInfo({
                buttonText: "Enabled Recent",
                method: () => enabledRecent = true,
                disableMethod: () => enabledRecent = false,
                toolTip: "Shows recently disabled mods in enabled mods."
            }),
            new ButtonInfo({
                buttonText: "Right Hand",
                method: () => righthand = true,
                disableMethod: () => righthand = false,
                toolTip: "Lets you switch menu hand."
            }),
            new ButtonInfo({
                buttonText: "Lerp Menu",
                method: () => LerpMenu = true,
                disableMethod: () => LerpMenu = false,
                toolTip: "Makes the menu Lerped."
            }),
            new ButtonInfo({
                buttonText: "High Punch Power",
                enableMethod: () => highPunchPower = true,
                disableMethod: () => highPunchPower = false,
                toolTip: "Makes punch mod more powerful."
            }),
            new ButtonInfo({
                buttonText: "ESP Collisions",
                enableMethod: () => {
                    for (let line of linePool) {
                        Destroy(line.method("get_gameObject").invoke());
                    }
                    linePool = [];
                    espCollide = true
                },
                disableMethod: () => {
                    for (let line of linePool) {
                        Destroy(line.method("get_gameObject").invoke());
                    }
                    linePool = [];
                    espCollide = false
                },
                toolTip: "Makes ESP have collisions."
            }),
        ],

        [ // Movement Mods [3]
            new ButtonInfo({
                buttonText: "Exit Movement Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
            new ButtonInfo({
                buttonText: "Fly Speed +",
                method: () => {
                    flySpeed += 5;
                    if (flySpeed > 100) {
                        flySpeed = 100;
                    }
                    sendNotification("Fly Speed: " + flySpeed);
                },
                isTogglable: false,
                toolTip: "Increases fly speed for Fly / Trigger Fly / Hand Fly."
            }),
            new ButtonInfo({
                buttonText: "Fly Speed -",
                method: () => {
                    flySpeed -= 5;
                    if (flySpeed < 5) {
                        flySpeed = 5;
                    }
                    sendNotification("Fly Speed: " + flySpeed);
                },
                isTogglable: false,
                toolTip: "Decreases fly speed for Fly / Trigger Fly / Hand Fly."
            }),
            new ButtonInfo({
                buttonText: "Long Arms",
                method: () => { try { getTransform(GTPlayer).method("set_localScale").invoke([1.2, 1.2, 1.2]); } catch (e) { console.error("Long Arms fail:", e); } },
                disableMethod: () => { try { getTransform(GTPlayer).method("set_localScale").invoke(oneVector); } catch (e) { } },
                toolTip: "Long arms (1.2x player scale)."
            }),
            new ButtonInfo({
                buttonText: "Mega Long Arms",
                method: () => { try { getTransform(GTPlayer).method("set_localScale").invoke([1.5, 1.5, 1.5]); } catch (e) { console.error("Mega Long Arms fail:", e); } },
                disableMethod: () => { try { getTransform(GTPlayer).method("set_localScale").invoke(oneVector); } catch (e) { } },
                toolTip: "Mega long arms (1.5x player scale)."
            }),

            new ButtonInfo({
                buttonText: "Platforms",
                method: () => {
                    if (leftGrab) {
                        if (leftPlatform == null) {
                            const handTransform = leftHandTransform;
                            leftPlatform = createObject(handTransform.method("get_position").invoke(), handTransform.method("get_rotation").invoke(), [0.025, 0.15, 0.2], 3, bgColor);
                        }
                    } else {
                        if (leftPlatform != null) {
                            Destroy(leftPlatform);
                            leftPlatform = null;
                        }
                    }

                    if (rightGrab) {
                        if (rightPlatform == null) {
                            const handTransform = rightHandTransform;
                            rightPlatform = createObject(handTransform.method("get_position").invoke(), handTransform.method("get_rotation").invoke(), [0.025, 0.15, 0.2], 3, bgColor);
                        }
                    } else {
                        if (rightPlatform != null) {
                            Destroy(rightPlatform);
                            rightPlatform = null;
                        }
                    }
                },
                toolTip: "Spawns platforms when pressing grip."
            }),

            new ButtonInfo({
                buttonText: "Trigger Platforms",
                method: () => {
                    if (leftTrigger) {
                        if (leftPlatform == null) {
                            const handTransform = leftHandTransform;
                            leftPlatform = createObject(handTransform.method("get_position").invoke(), handTransform.method("get_rotation").invoke(), [0.025, 0.15, 0.2], 3, bgColor);
                        }
                    } else {
                        if (leftPlatform != null) {
                            Destroy(leftPlatform);
                            leftPlatform = null;
                        }
                    }

                    if (rightTrigger) {
                        if (rightPlatform == null) {
                            const handTransform = rightHandTransform;
                            rightPlatform = createObject(handTransform.method("get_position").invoke(), handTransform.method("get_rotation").invoke(), [0.025, 0.15, 0.2], 3, bgColor);
                        }
                    } else {
                        if (rightPlatform != null) {
                            Destroy(rightPlatform);
                            rightPlatform = null;
                        }
                    }
                },
                toolTip: "Spawns platforms when pressing trigger."
            }),

            new ButtonInfo({
                buttonText: "Frozone",
                method: () => {
                    if (leftGrab) {
                        if (leftPlatform == null) {
                            const handTransform = leftHandTransform;
                            leftPlatform = createObject(handTransform.method("get_position").invoke(), handTransform.method("get_rotation").invoke(), [0.025, 0.15, 0.2], 3, bgColor);
                            addComponent(leftPlatform, GorillaSurfaceOverride).field("overrideIndex").value = 61;
                        }
                    } else {
                        if (leftPlatform != null) {
                            Destroy(leftPlatform);
                            leftPlatform = null;
                        }
                    }

                    if (rightGrab) {
                        if (rightPlatform == null) {
                            const handTransform = rightHandTransform;
                            rightPlatform = createObject(handTransform.method("get_position").invoke(), handTransform.method("get_rotation").invoke(), [0.025, 0.15, 0.2], 3, bgColor);
                            addComponent(rightPlatform, GorillaSurfaceOverride).field("overrideIndex").value = 61;
                        }
                    } else {
                        if (rightPlatform != null) {
                            Destroy(rightPlatform);
                            rightPlatform = null;
                        }
                    }
                },
                toolTip: "Spawns slippy platforms when pressing grip."
            }),

            new ButtonInfo({
                buttonText: "Fly",
                method: () => {
                    if (rightPrimary) {
                        rigidbody.method("set_velocity").invoke(Vector3.field("zeroVector").value);

                        const transform = getTransform(GorillaTagger);
                        let forward = getTransform(headCollider).method("get_forward").invoke();

                        let position = transform.method("get_position").invoke();
                        forward = Vector3.method("op_Multiply", 2).invoke(forward, flySpeed * deltaTime);

                        position = Vector3.method("op_Addition", 2).invoke(position, forward);

                        transform.method("set_position").invoke(position);
                    }
                },
                toolTip: "Lets you fly around while holding A."
            }),

            new ButtonInfo({
                buttonText: "Trigger Fly",
                method: () => {
                    if (rightTrigger) {
                        rigidbody.method("set_velocity").invoke(Vector3.field("zeroVector").value);

                        const transform = getTransform(GorillaTagger);
                        let forward = getTransform(headCollider).method("get_forward").invoke();

                        let position = transform.method("get_position").invoke();
                        forward = Vector3.method("op_Multiply", 2).invoke(forward, flySpeed * deltaTime);

                        position = Vector3.method("op_Addition", 2).invoke(position, forward);

                        transform.method("set_position").invoke(position);
                    }
                },
                toolTip: "Lets you fly around while holding trigger."
            }),

            new ButtonInfo({
                buttonText: "Hand Fly",
                method: () => {
                    if (rightPrimary) {
                        const mulQV = Quaternion.methods.find(m =>
                            m.name === "op_Multiply" &&
                            m.parameterCount === 2 &&
                            m.parameters[1].type.name.endsWith("Vector3")
                        ); // chatgpt no orhweer way to find this

                        rigidbody.method("set_velocity").invoke(Vector3.field("zeroVector").value);

                        const transform = getTransform(GorillaTagger);
                        const vrot = Quaternion.method("op_Multiply", 2).invoke(rightHandTransform.method("get_rotation").invoke(), GTPlayer.field("rightHand").field("handRotOffset").value);
                        const vfor = Vector3.method("get_forward").invoke();
                        let forward = mulQV.invoke(vrot, vfor);

                        let position = transform.method("get_position").invoke();
                        forward = Vector3.method("op_Multiply", 2).invoke(forward, flySpeed * deltaTime);

                        position = Vector3.method("op_Addition", 2).invoke(position, forward);

                        transform.method("set_position").invoke(position);
                    }
                },
                toolTip: "Lets you fly around with your hand while holding A."
            }),

            new ButtonInfo({
                buttonText: "Slow Time",
                method: () => {
                    const speed = -0.15;
                    let disp = Vector3.method("op_Addition", 2).invoke(rigidbody.method("get_linearVelocity").invoke(), Physics.method("get_gravity").invoke());
                    disp = Vector3.method("op_Multiply", 2).invoke(disp, Time.method("get_fixedDeltaTime").invoke() * speed);
                    rigidbody.method("MovePosition").invoke(Vector3.method("op_Addition", 2).invoke(rigidbody.method("get_position").invoke(), disp))
                },
                toolTip: "Slows down physics."
            }),

            new ButtonInfo({
                buttonText: "Quick Time",
                method: () => {
                    const speed = 0.15;
                    let disp = Vector3.method("op_Addition", 2).invoke(rigidbody.method("get_linearVelocity").invoke(), Physics.method("get_gravity").invoke());
                    disp = Vector3.method("op_Multiply", 2).invoke(disp, Time.method("get_fixedDeltaTime").invoke() * speed);
                    rigidbody.method("MovePosition").invoke(Vector3.method("op_Addition", 2).invoke(rigidbody.method("get_position").invoke(), disp))
                },
                toolTip: "Speeds up physics."
            }),

            new ButtonInfo({
                buttonText: "Up And Down",
                method: () => {
                    if (rightTrigger && rightGrab) {
                        rigidbody.method("set_velocity").invoke(Vector3.field("zeroVector").value);
                    }
                    if (rightTrigger && !rightGrab) {
                        rigidbody.method("AddForce").invoke(Vector3.field("upVector").value, 175 * deltaTime);
                    }
                    if (!rightTrigger && rightGrab) {
                        rigidbody.method("AddForce").invoke(Vector3.field("downVector").value, 175 * deltaTime);
                    }
                },
                toolTip: "Makes you go up when holding trigger, and down when holding grip."
            }),

            new ButtonInfo({
                buttonText: "Size Changer",
                disableMethod: () => {
                    GTPlayer.field("nativeScale").value = 1;
                    getTransform(LocalRig).method("set_localScale").invoke(Vector3.field("one").value.method("op_Multiply").invoke(LocalRig.field("NativeScale").value));
                },
                method: () => {
                    if (rightTrigger) {
                        GTPlayer.field("nativeScale").value += 0.01;
                        getTransform(LocalRig).method("set_localScale").invoke(Vector3.field("one").value.method("op_Multiply").invoke(LocalRig.field("NativeScale").value));
                    }
                    if (leftTrigger) {
                        GTPlayer.field("nativeScale").value -= 0.01;
                        getTransform(LocalRig).method("set_localScale").invoke(Vector3.field("one").value.method("op_Multiply").invoke(LocalRig.field("NativeScale").value));
                    }
                },
                toolTip: "Makes you able to change size with triggers."
            }),

            new ButtonInfo({
                buttonText: "Checkpoint",
                disableMethod: () => {
                    if (checkpoint != null) {
                        Destroy(checkpoint);
                        checkpoint = null;
                    }
                },
                method: () => {
                    if (rightGrab && !rightPrimary) {
                        if (checkpoint == null) {
                            const handTransform = rightHandTransform;
                            checkpoint = createObject(handTransform.method("get_position").invoke(), identityQuaternion, [0.2, 0.2, 0.2], 3, bgColor);
                            Destroy(getComponent(checkpoint, BoxCollider));
                        } else {
                            const handTransform = rightHandTransform;
                            checkpoint.method("get_transform").invoke().method("set_position").invoke(handTransform.method("get_position").invoke())
                        }
                    }
                    if (rightPrimary) {
                        if (checkpoint != null) {
                            teleportPlayer(checkpoint.method("get_transform").invoke().method("get_position").invoke())
                            rigidbody.method("set_velocity").invoke(zeroVector);
                        }
                    }
                },
                toolTip: "Place a checkpoint with grip and teleport to it with A."
            }),

            new ButtonInfo({
                buttonText: "Rewind",
                disableMethod: () => {
                    positions = [];
                },
                method: () => {
                    if (rightTrigger) {
                        const pos = positions[positions.length - 1];

                        teleportPlayer(pos[0]);
                        leftHandTransform.method("set_position").invoke(pos[1]);
                        rightHandTransform.method("set_position").invoke(pos[2]);
                        leftHandTransform.method("set_rotation").invoke(pos[3]);
                        rightHandTransform.method("set_rotation").invoke(pos[4]);
                        rigidbody.method("set_linearVelocity").invoke(pos[5]);

                        positions.pop();
                    } else {
                        positions.push([
                            bodyCollider.method("get_transform").invoke().method("get_position").invoke(),

                            leftHandTransform.method("get_position").invoke(),
                            rightHandTransform.method("get_position").invoke(),
                            
                            leftHandTransform.method("get_rotation").invoke(),
                            rightHandTransform.method("get_rotation").invoke(),

                            rigidbody.method("get_linearVelocity").invoke()
                        ]);
                        if (positions.length > 8640) {
                            positions.shift();
                        }
                    }
                },
                toolTip: "Brings you back in time when holding trigger."
            }),

            new ButtonInfo({
                buttonText: "No Tag Freeze",
                method: () => GTPlayer.field("disableMovement").value = false,
                toolTip: "Disables tag freeze on your character.",
            }),

            new ButtonInfo({
                buttonText: "Low Gravity",
                method: () => {
                    const force = Vector3.method("op_Multiply", 2).invoke(Vector3.field("upVector").value, (deltaTime * (6.66 / deltaTime)));
                    rigidbody.method("AddForce", 2).invoke(force, 5);
                },
                toolTip: "Makes gravity lower on your character."
            }),

            new ButtonInfo({
                buttonText: "Zero Gravity",
                method: () => {
                    const force = Vector3.method("op_Multiply", 2).invoke(Vector3.field("upVector").value, (deltaTime * (9.81 / deltaTime)));
                    rigidbody.method("AddForce", 2).invoke(force, 5);
                },
                toolTip: "Makes gravity lower on your character."
            }),

            new ButtonInfo({
                buttonText: "High Gravity",
                method: () => {
                    const force = Vector3.method("op_Multiply", 2).invoke(Vector3.field("downVector").value, (deltaTime * (7.77 / deltaTime)));
                    rigidbody.method("AddForce", 2).invoke(force, 5);
                },
                toolTip: "Makes gravity higher on your character."
            }),

            new ButtonInfo({
                buttonText: "Weak Wall Walk",
                method: () => {
                    if (GTPlayer.method("IsHandTouching").invoke(true) || GTPlayer.method("IsHandTouching").invoke(false)) {
                        const ray = GTPlayer.field("lastHitInfoHand").value;
                        walkPos = ray.method("get_point").invoke();
                        walkNormal = ray.method("get_normal").invoke();
                    }
                    if (walkPos != Vector3.field("zeroVector").value && rightGrab) {
                        const force = Vector3.method("op_Multiply", 2).invoke(walkNormal, -5);
                        rigidbody.method("AddForce").invoke(force, 5);
                        const zeroForce = Vector3.method("op_Multiply", 2).invoke(Vector3.field("upVector").value, (deltaTime * (9.81 / deltaTime)));
                        rigidbody.method("AddForce", 2).invoke(zeroForce, 5);
                    }
                },
                toolTip: "Makes you get brought towards any wall you touch when holding grip, but weaker."
            }),

            new ButtonInfo({
                buttonText: "Wall Walk",
                method: () => {
                    if (GTPlayer.method("IsHandTouching").invoke(true) || GTPlayer.method("IsHandTouching").invoke(false)) {
                        const ray = GTPlayer.field("lastHitInfoHand").value;
                        walkPos = ray.method("get_point").invoke();
                        walkNormal = ray.method("get_normal").invoke();
                    }
                    if (walkPos != Vector3.field("zeroVector").value && rightGrab) {
                        const force = Vector3.method("op_Multiply", 2).invoke(walkNormal, -9.81);
                        rigidbody.method("AddForce").invoke(force, 5);
                        const zeroForce = Vector3.method("op_Multiply", 2).invoke(Vector3.field("upVector").value, (deltaTime * (9.81 / deltaTime)));
                        rigidbody.method("AddForce", 2).invoke(zeroForce, 5);
                    }
                },
                toolTip: "Makes you get brought towards any wall you touch when holding grip."
            }),

            new ButtonInfo({
                buttonText: "Teleport Gun",
                method: () => {
                    if (rightGrab) {
                        const gunData = renderGun();
                        const gunPointer = gunData.gunPointer;

                        if (rightTrigger && !perviousTeleportKey) {
                            teleportPlayer(getTransform(gunPointer).method("get_position").invoke())
                            rigidbody.method("set_velocity").invoke(zeroVector);
                        }

                        perviousTeleportKey = rightTrigger;
                    }
                },
                toolTip: "Teleports you to wherever your hand desires."
            }),

            new ButtonInfo({
                buttonText: "Airstrike Gun",
                method: () => {
                    if (rightGrab) {
                        const gunData = renderGun();
                        const gunPointer = gunData.gunPointer;

                        if (rightTrigger && !perviousTeleportKey) {
                            teleportPlayer(Vector3.method("op_Addition", 2).invoke([0, 30, 0], getTransform(gunPointer).method("get_position").invoke()))
                            rigidbody.method("set_velocity").invoke(zeroVector);
                        }

                        perviousTeleportKey = rightTrigger;
                    }
                },
                toolTip: "Teleports you to wherever your hand desires, except farther up, then launches you back down."
            }),

            new ButtonInfo({
                buttonText: "Airstrike Random",
                method: () => {
                    const vrrigs = GorillaParent.field("vrrigs").value;
                    const vrrigtotal = vrrigs.method("get_Count").invoke();
                    const playerRig = vrrigs.method("get_Item").invoke(Math.floor(Math.random() * vrrigtotal));
                    teleportPlayer(Vector3.method("op_Addition", 2).invoke([0, 30, 0], getTransform(playerRig).method("get_position").invoke()));
                    rigidbody.method("set_velocity").invoke(zeroVector);
                },
                isTogglable: false,
                toolTip: "Teleports you to a random player, except farther up, then launches you back down."
            }),

            new ButtonInfo({
                buttonText: "Teleport To Random",
                method: () => {
                    const vrrigs = GorillaParent.field("vrrigs").value;
                    const vrrigtotal = vrrigs.method("get_Count").invoke();
                    const playerRig = vrrigs.method("get_Item").invoke(Math.floor(Math.random() * vrrigtotal));
                    teleportPlayer(getTransform(playerRig).method("get_position").invoke());
                    rigidbody.method("set_velocity").invoke(zeroVector);
                },
                isTogglable: false,
                toolTip: "Teleports you to a random player."
            }),

            new ButtonInfo({
                buttonText: "Dash",
                method: () => {
                    if (rightPrimary && !previousDash) {
                        const leftRightVector = getTransform(headCollider).method("get_forward").invoke();
                        const leftForce = Vector3.method("op_Multiply", 2).invoke(leftRightVector, 10.0);
                        rigidbody.method("AddForce", 2).invoke(leftForce, 2);
                    }
                    previousDash = rightPrimary;
                },
                toolTip: "Flings your character forwards when pressing A."
            }),

            new ButtonInfo({
                buttonText: "Iron Man",
                method: () => {
                    if (leftPrimary) {
                        const leftRightVector = leftHandTransform.method("get_right").invoke();
                        const leftForce = Vector3.method("op_Multiply", 2).invoke(leftRightVector, -15.0 * deltaTime);
                        rigidbody.method("AddForce", 2).invoke(leftForce, 2);
                    }
                    if (rightPrimary) {
                        const leftRightVector = rightHandTransform.method("get_right").invoke();
                        const leftForce = Vector3.method("op_Multiply", 2).invoke(leftRightVector, 15.0 * deltaTime);
                        rigidbody.method("AddForce", 2).invoke(leftForce, 2);
                    }
                },
                toolTip: "Turns you into iron man. Use A and X to fly."
            }),

            new ButtonInfo({
                buttonText: "Noclip",
                method: () => {
                    if (rightTrigger && !previousNoclipKey) {
                        toggleColliders(false);
                    }

                    if (!rightTrigger && previousNoclipKey) {
                        toggleColliders(true);
                    }

                    previousNoclipKey = rightTrigger;
                },
                toolTip: "Lets you clip through objects while holding right trigger."
            }),

            new ButtonInfo({
                buttonText: "Legit Long Arms",
                method: () => {
                    getTransform(GorillaTagger).method("set_localScale").invoke([1.08, 1.08, 1.08]);
                },
                disableMethod: () => {
                    getTransform(GorillaTagger).method("set_localScale").invoke(oneVector);
                },
                toolTip: "Gives you Slightly longer arms."
            }),

            new ButtonInfo({
                buttonText: "Long Arms",
                method: () => {
                    getTransform(GorillaTagger).method("set_localScale").invoke([1.25, 1.25, 1.25]);
                },
                disableMethod: () => {
                    getTransform(GorillaTagger).method("set_localScale").invoke(oneVector);
                },
                toolTip: "Gives you longer arms."
            }),

            new ButtonInfo({
                buttonText: "Speed Boost",
                method: () => {
                    GTPlayer.field("maxJumpSpeed").value = 9.0;
                    GTPlayer.method("set_jumpMultiplier").invoke(1.5);
                },
                toolTip: "Gives you a speed boost."
            }),

            new ButtonInfo({
                buttonText: "Slide Control",
                enableMethod: () => {
                    oldSlide = GTPlayer.field("slideControl").value;
                    GTPlayer.field("slideControl").value = 1;
                },
                disableMethod: () => GTPlayer.field("slideControl").value = oldSlide,
                toolTip: "Lets you control yourself on ice perfectly."
            }),

            new ButtonInfo({
                buttonText: "Predictions",
                enableMethod: () => {
                    lvT = createObject(zeroVector, identityQuaternion, zeroVector, 0, [0.0, 0.0, 0.0, 0.0]);
                    Destroy(getComponent(lvT, BoxCollider))
                    addComponent(lvT, GorillaVelocityTracker);

                    rvT = createObject(zeroVector, identityQuaternion, zeroVector, 0, [0.0, 0.0, 0.0, 0.0]);
                    Destroy(getComponent(rvT, BoxCollider))
                    addComponent(rvT, GorillaVelocityTracker);
                },
                method: () => {
                    let predCount = 0.02;

                    getTransform(lvT).method("set_position").invoke(Vector3.method("op_Subtraction", 2).invoke(getTransform(headCollider).method("get_position").invoke(), leftHandTransform.method("get_position").invoke()));
                    getTransform(rvT).method("set_position").invoke(Vector3.method("op_Subtraction", 2).invoke(getTransform(headCollider).method("get_position").invoke(), rightHandTransform.method("get_position").invoke()));

                    let leftHandPosition = leftHandTransform.method("get_position").invoke();
                    let rightHandPosition = rightHandTransform.method("get_position").invoke();

                    let leftHandVelocity = getComponent(lvT, GorillaVelocityTracker).method("GetAverageVelocity").invoke(true, 0.0, false);
                    let rightHandVelocity = getComponent(rvT, GorillaVelocityTracker).method("GetAverageVelocity").invoke(true, 0.0, false);

                    leftHandVelocity = Vector3.method("op_Multiply", 2).invoke(leftHandVelocity, predCount);
                    rightHandVelocity = Vector3.method("op_Multiply", 2).invoke(rightHandVelocity, predCount);

                    leftHandPosition = Vector3.method("op_Subtraction", 2).invoke(leftHandPosition, leftHandVelocity);
                    rightHandPosition = Vector3.method("op_Subtraction", 2).invoke(rightHandPosition, rightHandVelocity);

                    leftHandTransform.method("set_position").invoke(leftHandPosition);
                    rightHandTransform.method("set_position").invoke(rightHandPosition);
                },
                disableMethod: () => {
                    Destroy(lvT);
                    Destroy(rvT);
                },
                toolTip: "Gives your controllers higher predictions."
            }),
        ],

        [ // Fun Mods [4]
            new ButtonInfo({
                buttonText: "Exit Fun Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
            new ButtonInfo({
                buttonText: "Spawn Hoverboard",
                method: () => {
                    GTPlayer.method("SetHoverAllowed").invoke(true, true)
                    FreeHoverboardManager.method("SendDropBoardRPC").invoke(rightHandTransform.method("get_position").invoke(), identityQuaternion, zeroVector, zeroVector, bgColor);
                },
                isTogglable: false,
                toolTip: "Spawns you in a hoverboard."
            }),
            new ButtonInfo({
                buttonText: "Become Goldentrophy",
                method: () => {
                    setPlayerName("goldentrophy");
                    setPlayerColor([1.0, 0.5, 0.0]);
                },
                isTogglable: false,
                toolTip: "Turns you into goldentrophy."
            }),
            new ButtonInfo({
                buttonText: "Water Splash Hands",
                method: () => {
                    if (leftGrab && time > splashDelay) {
                        splashDelay = time + 0.1;
                        const objectArray = Il2Cpp.array(SystemObject, [leftHandTransform.method("get_position").invoke(), leftHandTransform.method("get_rotation").invoke(), 1.0, 0.5, true, false]);

                        const method = GorillaTagger.method("get_myVRRig").invoke().method("SendRPC", 3).overload(
                            "System.String",
                            "Photon.Pun.RpcTarget",
                            "System.Object[]");

                        method.invoke(Il2Cpp.string("RPC_PlaySplashEffect"), 0, objectArray);
                    }
                    if (rightGrab && time > splashDelay) {
                        splashDelay = time + 0.1;
                        const objectArray = Il2Cpp.array(SystemObject, [rightHandTransform.method("get_position").invoke(), rightHandTransform.method("get_rotation").invoke(), 1.0, 0.5, true, false]);

                        const method = GorillaTagger.method("get_myVRRig").invoke().method("SendRPC", 3).overload(
                            "System.String",
                            "Photon.Pun.RpcTarget",
                            "System.Object[]");

                        method.invoke(Il2Cpp.string("RPC_PlaySplashEffect"), 0, objectArray);
                    }
                },
                toolTip: "Splashes water on your hands when pressing your grips."
            }),
            new ButtonInfo({
                buttonText: "Get ID Gun",
                method: () => {
                    if (rightGrab) {
                        const gunData = renderGun();
                        const ray = gunData.ray;

                        if (rightTrigger) {
                            const gunTarget = getComponentInParent(ray.method("get_collider").invoke(), VRRig);
                            if (gunTarget && !gunTarget.handle.isNull() && time > idGunDelay) {
                                if (!playerIsLocal(gunTarget)) {
                                    idGunDelay = time + 0.5;
                                    const id = gunTarget.method("get_Creator").invoke().method("get_UserId").invoke();
                                    sendNotification("ID: " + String(id));
                                }
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Logs the ID of whoever your hand desires."
            }),
            new ButtonInfo({
                buttonText: "Get Platform Gun",
                method: () => {
                    if (rightGrab) {
                        const gunData = renderGun();
                        const ray = gunData.ray;

                        if (rightTrigger) {
                            const gunTarget = getComponentInParent(ray.method("get_collider").invoke(), VRRig);
                            if (gunTarget && !gunTarget.handle.isNull() && time > idGunDelay) {
                                if (!playerIsLocal(gunTarget)) {
                                    idGunDelay = time + 0.5;
                                    const player = gunTarget.method("get_Creator").invoke();
                                    const concat = String(gunTarget.field("concatStringOfCosmeticsAllowed").value);
                                    const isSteam = (concat.includes("S. FIRST LOGIN") || concat.includes("FIRST LOGIN")) && !concat.includes("LMAKT.");
                                    sendNotification(isSteam ? "PLATFORM: Steam" : "PLATFORM: Meta");
                                }
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Logs the platform of whoever your hand desires."
            }),
            new ButtonInfo({
                buttonText: "Punch Mod",
                method: () => {
                    // This is MORE optimized (BY A LOT) than the one in the steam menu.
                    const vrrigs = GorillaParent.field("vrrigs").value;
                    const vrrigtotal = vrrigs.method("get_Count").invoke();
                    let index = 0;
                    for (let i = 0; i < vrrigtotal; i++) {
                        const vrrig = vrrigs.method("get_Item").invoke(i);
                        index++;
                        let they = vrrig.field("rightHandTransform").value.method("get_position").invoke();
                        const notthem = getTransform(headCollider).method("get_position").invoke();
                        let distance = Vector3.method("Distance").invoke(they, notthem);
                        if (distance < 0.25) {
                            const vel = Vector3.method("op_Addition", 2).invoke(Vector3.method("op_Multiply").invoke(Vector3.method("Normalize").invoke(Vector3.method("op_Subtraction", 2).invoke(they, punchLastRight[index])), highPunchPower ? 10 : 5), rigidbody.method("get_velocity").invoke());
                            rigidbody.method("set_velocity").invoke(vel);
                        }
                        punchLastRight[index] = they;
                        they = vrrig.field("leftHandTransform").value.method("get_position").invoke();
                        distance = Vector3.method("Distance").invoke(they, notthem);
                        if (distance < 0.25) {
                            const vel = Vector3.method("op_Addition", 2).invoke(Vector3.method("op_Multiply").invoke(Vector3.method("Normalize").invoke(Vector3.method("op_Subtraction", 2).invoke(they, punchLastLeft[index])), highPunchPower ? 10 : 5), rigidbody.method("get_velocity").invoke());
                            rigidbody.method("set_velocity").invoke(vel);
                        }
                        punchLastLeft[index] = they;
                    }
                },
                toolTip: "Lets people punch you across the map."
            }),
            new ButtonInfo({
                buttonText: "Max Quest Score",
                method: () => {
                    LocalRig.method("SetQuestScore")?.invoke(999999)
                },
                isTogglable: false,
                toolTip: "Sets Your Quest Score To Max"
            }),
            new ButtonInfo({
                buttonText: "Max Ranked Level",
                method: () => {
                    LocalRig.method("SetRankedInfo", 4)?.invoke(4000.0, 7, 7, true);
                },
                isTogglable: false,
                toolTip: "Sets Your Ranked Level To Max"
            }),
        ],

        [ // Advantage Mods [5]
            new ButtonInfo({
                buttonText: "Exit Advantage Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),

            new ButtonInfo({
                buttonText: "Hand Noclip",
                method: () => {
                    GTPlayer.field("leftHandHolding").value = true;
                    GTPlayer.field("rightHandHolding").value = true;
                },
                disableMethod: () => {
                    GTPlayer.field("leftHandHolding").value = false;
                    GTPlayer.field("rightHandHolding").value = false;
                },
                toolTip: "Disables hand collisions."
            }),

            new ButtonInfo({
                buttonText: "Tag Gun",
                method: () => {
                    if (rightGrab) {
                        const gunData = renderGun();
                        const ray = gunData.ray;

                        if (rightTrigger) {
                            const gunTarget = getComponentInParent(ray.method("get_collider").invoke(), VRRig);
                            if (gunTarget && !gunTarget.handle.isNull() && time > tagGunDelay) {
                                if (!playerIsLocal(gunTarget)) {
                                    tagGunDelay = time + 0.5;
                                    LocalRig.method("set_enabled").invoke(false);
                                    getTransform(LocalRig).method("set_position").invoke(getTransform(gunTarget).method("get_position").invoke());
                                    serialize();
                                    GameMode.method("ReportTag").invoke(gunTarget.method("get_Creator").invoke());
                                    LocalRig.method("set_enabled").invoke(true);
                                    sendAllOutgoing();
                                }
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Tags whoever your hand desires."
            }),

            new ButtonInfo({
    buttonText: "Tag All",
    isTogglable: false,
    method: () => {
        try {
            const vrrigs = GorillaParent.field("vrrigs").value;
            if (vrrigs == null) {
                sendNotification("No players found");
                return;
            }
            
            const vrrigtotal = vrrigs.method("get_Count").invoke();
            console.log("Tag All: найдено " + vrrigtotal + " игроков");
            
            let taggedCount = 0;
            for (let i = 0; i < vrrigtotal; i++) {
                try {
                    const playerRig = vrrigs.method("get_Item").invoke(i);
                    
                    if (!playerIsLocal(playerRig)) {
                        console.log("Tag All: теггирую игрока " + i);
                        
                        // Телепортируем СЕБЯ на позицию игрока
                        LocalRig.method("set_enabled").invoke(false);
                        const targetPos = getTransform(playerRig).method("get_position").invoke();
                        getTransform(LocalRig).method("set_position").invoke(targetPos);
                        
                        serialize();
                        GameMode.method("ReportTag").invoke(playerRig.method("get_Creator").invoke());
                        
                        LocalRig.method("set_enabled").invoke(true);
                        sendAllOutgoing();
                        
                        taggedCount++;
                    }
                } catch (e) {
                    console.error("Tag All: ошибка при теггировании игрока " + i + ":", e);
                }
            }
            
            sendNotification("Tagged " + taggedCount + " players");
            console.log("Tag All: успешно теггировано " + taggedCount);
        } catch (e) {
            console.error("Tag All error:", e);
            sendNotification("Tag All failed");
        }
    },
    toolTip: "Tags everyone"
}),

            new ButtonInfo({
                buttonText: "72 FPS",
                method: () => {
                    const targetDelta = 1 / 72;
                    const elapsed = Time.method("get_realtimeSinceStartup").invoke() - lastTime;
                    if (elapsed < targetDelta) {
                        const sleepMs = Math.floor((targetDelta - elapsed) * 1000);
                        if (sleepMs > 0)
                            Thread.method("Sleep").invoke(sleepMs);
                    }
                    lastTime = Time.method("get_realtimeSinceStartup").invoke();
                },
                isTogglable: true,
                toolTip: "Caps your FPS at 72 frames per second."
            }),

            new ButtonInfo({
                buttonText: "60 FPS",
                method: () => {
                    const targetDelta = 1 / 60;
                    const elapsed = Time.method("get_realtimeSinceStartup").invoke() - lastTime;
                    if (elapsed < targetDelta) {
                        const sleepMs = Math.floor((targetDelta - elapsed) * 1000);
                        if (sleepMs > 0)
                            Thread.method("Sleep").invoke(sleepMs);
                    }
                    lastTime = Time.method("get_realtimeSinceStartup").invoke();
                },
                isTogglable: true,
                toolTip: "Caps your FPS at 60 frames per second."
            }),

            new ButtonInfo({
                buttonText: "45 FPS",
                method: () => {
                    const targetDelta = 1 / 45;
                    const elapsed = Time.method("get_realtimeSinceStartup").invoke() - lastTime;
                    if (elapsed < targetDelta) {
                        const sleepMs = Math.floor((targetDelta - elapsed) * 1000);
                        if (sleepMs > 0)
                            Thread.method("Sleep").invoke(sleepMs);
                    }
                    lastTime = Time.method("get_realtimeSinceStartup").invoke();
                },
                isTogglable: true,
                toolTip: "Caps your FPS at 45 frames per second."
            }),
        ],
        [ // Rig Mods [6]
            new ButtonInfo({
                buttonText: "Exit Rig Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
            
            new ButtonInfo({
                buttonText: "Disable Wind",
                enableMethod: () => { // yes, this is the placement of the mod in the steam menu. correct category and all.
                    getObject("Environment Objects/LocalObjects_Prefab/Forest/Environment/Forest_ForceVolumes/").method("SetActive").invoke(false);
                },
                disableMethod: () => {
                    getObject("Environment Objects/LocalObjects_Prefab/Forest/Environment/Forest_ForceVolumes/").method("SetActive").invoke(true);
                },
                toolTip: "Freezes your rig when pressing A."
            }),

            new ButtonInfo({
                buttonText: "Ghost",
                method: () => {
                    if (rightPrimary && !previousGhostKey) {
                        LocalRig.method("set_enabled").invoke(!LocalRig.method("get_enabled").invoke());
                    }
                    previousGhostKey = rightPrimary;
                },
                toolTip: "Freezes your rig when pressing A."
            }),

            new ButtonInfo({
                buttonText: "Invisible",
                method: () => {
                    if (rightSecondary && !previousInvisKey) {
                        LocalRig.method("set_enabled").invoke(!LocalRig.method("get_enabled").invoke());
                    }
                    if (!LocalRig.method("get_enabled").invoke()) {
                        getTransform(LocalRig).method("set_position").invoke([0, -99999, 0]);
                    }
                    previousInvisKey = rightSecondary;

                },
                toolTip: "Turns you invisible when pressing B."
            }),
            new ButtonInfo({
                buttonText: "Rig Gun",
                disableMethod: () => {
                    LocalRig.method("set_enabled").invoke(true);
                },
                method: () => {
                    if (rightGrab) {
                        const gunData = renderGun();
                        const gunPointer = gunData.gunPointer;

                        if (rightTrigger) {
                            LocalRig.method("set_enabled").invoke(false);
                            const position = Vector3.method("op_Addition", 2).invoke([0, 1, 0], getTransform(gunPointer).method("get_position").invoke());
                            getTransform(LocalRig).method("set_position").invoke(position);
                        } else {
                            LocalRig.method("set_enabled").invoke(true);
                        }
                    }
                },
                toolTip: "Moves your rig to wherever your hand desires."
            }),
            new ButtonInfo({
                buttonText: "Grab Rig",
                disableMethod: () => { LocalRig.method("set_enabled").invoke(true); },
                method: () => {
                    if (rightGrab) {
                        LocalRig.method("set_enabled").invoke(false);
                        getTransform(LocalRig).method("set_position").invoke(rightHandTransform.method("get_position").invoke());
                        getTransform(LocalRig).method("set_rotation").invoke(rightHandTransform.method("get_rotation").invoke());
                    }
                    else {
                        LocalRig.method("set_enabled").invoke(true);
                    }
                    if (leftGrab) {
                        LocalRig.method("set_enabled").invoke(false);
                        getTransform(LocalRig).method("set_position").invoke(leftHandTransform.method("get_position").invoke());
                        getTransform(LocalRig).method("set_rotation").invoke(leftHandTransform.method("get_rotation").invoke());
                    }
                    else {
                        LocalRig.method("set_enabled").invoke(true);
                    }
                },
                isTogglable: true,
                toolTip: "Lets you grab your rig"
            }),
            new ButtonInfo({
                buttonText: "Spaz Rig",
                method: () => {
                    const trackingRotationOffset = LocalRig.field("head").value.field("trackingRotationOffset").value;
                    trackingRotationOffset.field("x").value = Math.random() * 360.0;
                    trackingRotationOffset.field("y").value = Math.random() * 360.0;
                    trackingRotationOffset.field("z").value = Math.random() * 360.0;
                },
                disableMethod: () => {
                    const trackingRotationOffset = LocalRig.field("head").value.field("trackingRotationOffset").value;
                    trackingRotationOffset.field("x").value = 0.0;
                    trackingRotationOffset.field("y").value = 0.0;
                    trackingRotationOffset.field("z").value = 0.0;
                },
                toolTip: "Spazzes your rig out."
            }),
            new ButtonInfo({
                buttonText: "Spin Head X",
                method: () => {
                    const trackingRotationOffset = LocalRig.field("head").value.field("trackingRotationOffset").value;
                    trackingRotationOffset.field("x").value += 15.0;
                },
                disableMethod: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("x").value = 0.0;
                },
                toolTip: "Rotate head around the X axis."
            }),

            new ButtonInfo({
                buttonText: "Spin Head Y",
                method: () => {
                    const trackingRotationOffset = LocalRig.field("head").value.field("trackingRotationOffset").value;
                    trackingRotationOffset.field("y").value += 15.0;
                },
                disableMethod: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("y").value = 0.0;
                },
                toolTip: "Rotate head around the Y axis."
            }),

            new ButtonInfo({
                buttonText: "Spin Head Z",
                method: () => {
                    const trackingRotationOffset = LocalRig.field("head").value.field("trackingRotationOffset").value;
                    trackingRotationOffset.field("z").value += 15.0;
                },
                disableMethod: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("z").value = 0.0;
                },
                toolTip: "Rotate head around the Z axis."
            }),
            new ButtonInfo({
                buttonText: "Upside Down Head",
                method: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("z").value = 180.0;
                },
                disableMethod: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("z").value = 0.0;
                },
                toolTip: "Flip your head upside down."
            }),

            new ButtonInfo({
                buttonText: "Broken Neck",
                method: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("z").value = 90.0;
                },
                disableMethod: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("z").value = 0.0;
                },
                toolTip: "Tilt your head sideways."
            }),

            new ButtonInfo({
                buttonText: "Backwards Head",
                method: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("y").value = 180.0;
                },
                disableMethod: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("y").value = 0.0;
                },
                toolTip: "Turn your head backwards."
            }),

            new ButtonInfo({
                buttonText: "Sideways Head",
                method: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("y").value = 90.0;
                },
                disableMethod: () => {
                    LocalRig.field("head").value.field("trackingRotationOffset").value.field("y").value = 0.0;
                },
                toolTip: "Rotate your head sideways."
            }),
        ],
        [ // Misc Mods [7]
            new ButtonInfo({
                buttonText: "Exit Misc Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
            new ButtonInfo({
                buttonText: "Connect to US",
                method: () => {
                    PhotonNetwork.method("ConnectToRegion").invoke(Il2Cpp.string("us"));
                },
                isTogglable: false,
                toolTip: "Connects you to the US region."
            }),

            new ButtonInfo({
                buttonText: "Connect to US West",
                method: () => {
                    PhotonNetwork.method("ConnectToRegion").invoke(Il2Cpp.string("usw"));
                },
                isTogglable: false,
                toolTip: "Connects you to the USW rwgion."
            }),

            new ButtonInfo({
                buttonText: "Connect to EU",
                method: () => {
                    PhotonNetwork.method("ConnectToRegion").invoke(Il2Cpp.string("eu"));
                },
                isTogglable: false,
                toolTip: "Connects you to the EU region."
            }),
        ],
        [ // Visual Mods [8]
            new ButtonInfo({
                buttonText: "Exit Visual Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
            new ButtonInfo({
                buttonText: "Cosmetic Tracers",
                disableMethod: () => {
                    for (let line of linePool) {
                        line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                    }
                },
                method: () => {
                    if (frameCount % 5 != 0) {
                        for (let line of linePool) {
                            line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                        }
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        const rigs = [];
                        const cosmeticRigs = [];
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            rigs.push(playerRig);
                            if (playerIsLocal(playerRig)) continue;
                            const concat = String(playerRig.field("concatStringOfCosmeticsAllowed").value);
                            if (concat.includes("LBAAD.")) { cosmeticRigs.push(i); continue; }; // Admin
                            if (concat.includes("LBAAK.")) { cosmeticRigs.push(i); continue; }; // Stick
                            if (concat.includes("LMAPY.")) { cosmeticRigs.push(i); continue; }; // Forest Guide
                            if (concat.includes("LBAGS.")) { cosmeticRigs.push(i); continue; }; // Illustrator
                            if (concat.includes("LBADE.")) { cosmeticRigs.push(i); continue; }; // Finger Painter
                            if (concat.includes("LBANI.")) { cosmeticRigs.push(i); continue; }; // AA Creator
                        }
                        for (let i = 0; i < vrrigtotal; i++) {
                            if (cosmeticRigs.includes(i) == false) continue;
                            const playerRig = rigs[i];
                            if (!playerIsLocal(playerRig)) {
                                const color = playerRig.field("playerColor").value;
                                if (lineRenderHolder == null) {
                                    lineRenderHolder = GameObject.new("LineRender_Holder");
                                }
                                let finalRender = null;
                                let nl = false;
                                for (let line of linePool) {
                                    if (finalRender != null) continue;
                                    if (line.method("get_gameObject").invoke().method("get_activeInHierarchy").invoke() == false) {
                                        line.method("get_gameObject").invoke().method("SetActive").invoke(true);
                                        finalRender = line;
                                        break;
                                    }
                                }
                                if (finalRender == null) {
                                    nl = true;
                                    const lineHolder = GameObject.new("LineObject");
                                    getTransform(lineHolder).method("set_parent").invoke(getTransform(lineRenderHolder));
                                    const newLine = addComponent(lineHolder, LineRenderer);
                                    const shader = Shader.method("Find").overload("System.String").invoke(Il2Cpp.string("GUI/Text Shader"));
                                    newLine.method("get_material").invoke().method("set_shader").invoke(shader);
                                    newLine.method("set_startWidth").invoke(0.025);
                                    newLine.method("set_endWidth").invoke(0.025);
                                    newLine.method("get_gameObject").invoke().method("SetActive").invoke(true);
                                    newLine.method("set_useWorldSpace").invoke(true);
                                    newLine.method("get_gameObject").invoke().method("set_layer").invoke(lineRenderHolder.method("get_layer").invoke());
                                    linePool.push(newLine);
                                    finalRender = newLine;
                                }
                                finalRender.method("set_startColor").invoke(color);
                                finalRender.method("set_endColor").invoke(color);
                                finalRender.method("SetPosition").invoke(1, getTransform(playerRig).method("get_position").invoke());
                                finalRender.method("SetPosition").invoke(0, rightHandTransform.method("get_position").invoke());
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Puts tracers on your right hand. Only shows players with rare cosmetics."
            }),
            new ButtonInfo({
                buttonText: "Casual Tracers",
                disableMethod: () => {
                    for (let line of linePool) {
                        line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                    }
                },
                method: () => {
                    if (frameCount % 3 == 0) {
                        for (let line of linePool) {
                            line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                        }
                        const rhp = rightHandTransform.method("get_position").invoke();
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            if (!playerIsLocal(playerRig)) {
                                const color = playerRig.field("playerColor").value;
                                if (lineRenderHolder == null) {
                                    lineRenderHolder = GameObject.new("LineRender_Holder");
                                }
                                let finalRender = null;
                                let nl = false;
                                for (let line of linePool) {
                                    if (finalRender != null) continue;
                                    const lineObj = line.method("get_gameObject").invoke();
                                    if (lineObj.method("get_activeInHierarchy").invoke() == false) {
                                        lineObj.method("SetActive").invoke(true);
                                        finalRender = line;
                                        break;
                                    }
                                }
                                if (finalRender == null) {
                                    nl = true;
                                    const lineHolder = GameObject.new("LineObject");
                                    getTransform(lineHolder).method("set_parent").invoke(getTransform(lineRenderHolder));
                                    const newLine = addComponent(lineHolder, LineRenderer);
                                    const shader = Shader.method("Find").overload("System.String").invoke(Il2Cpp.string("GUI/Text Shader"));
                                    newLine.method("get_material").invoke().method("set_shader").invoke(shader);
                                    newLine.method("set_startWidth").invoke(0.025);
                                    newLine.method("set_endWidth").invoke(0.025);
                                    newLine.method("get_gameObject").invoke().method("SetActive").invoke(true);
                                    newLine.method("set_useWorldSpace").invoke(true);
                                    newLine.method("get_gameObject").invoke().method("set_layer").invoke(lineRenderHolder.method("get_layer").invoke());
                                    linePool.push(newLine);
                                    finalRender = newLine;
                                }
                                finalRender.method("set_startColor").invoke(color);
                                finalRender.method("set_endColor").invoke(color);
                                finalRender.method("SetPosition").invoke(0, rhp);
                                if (frameCount % 6 == 0)
                                    finalRender.method("SetPosition").invoke(1, getTransform(playerRig).method("get_position").invoke());
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Puts tracers on your right hand. Shows everyone."
            }),
            new ButtonInfo({
                buttonText: "Nearest Tracer",
                disableMethod: () => {
                    for (let line of linePool) {
                        line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                    }
                },
                method: () => {
                    if (frameCount % 5 != 0) {
                        let lowestDistance = Number.MAX_SAFE_INTEGER;
                        let closest = 0;
                        for (let line of linePool) {
                            line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                        }
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        const rigs = [];
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            rigs.push(playerRig);
                            if (playerIsLocal(playerRig)) continue;
                            const dist = Vector3.method("Distance").invoke(getTransform(headCollider).method("get_position").invoke(), getTransform(playerRig).method("get_position").invoke());
                            if (lowestDistance > dist) {
                                lowestDistance = dist;
                                closest = i;
                            }
                        }
                        for (let i = 0; i < vrrigtotal; i++) {
                            if (i != closest) continue;
                            const playerRig = rigs[i];
                            if (!playerIsLocal(playerRig)) {
                                const color = playerRig.field("playerColor").value;
                                if (lineRenderHolder == null) {
                                    lineRenderHolder = GameObject.new("LineRender_Holder");
                                }
                                let finalRender = null;
                                let nl = false;
                                for (let line of linePool) {
                                    if (finalRender != null) continue;
                                    if (line.method("get_gameObject").invoke().method("get_activeInHierarchy").invoke() == false) {
                                        line.method("get_gameObject").invoke().method("SetActive").invoke(true);
                                        finalRender = line;
                                        break;
                                    }
                                }
                                if (finalRender == null) {
                                    nl = true;
                                    const lineHolder = GameObject.new("LineObject");
                                    getTransform(lineHolder).method("set_parent").invoke(getTransform(lineRenderHolder));
                                    const newLine = addComponent(lineHolder, LineRenderer);
                                    const shader = Shader.method("Find").overload("System.String").invoke(Il2Cpp.string("GUI/Text Shader"));
                                    newLine.method("get_material").invoke().method("set_shader").invoke(shader);
                                    newLine.method("set_startWidth").invoke(0.025);
                                    newLine.method("set_endWidth").invoke(0.025);
                                    newLine.method("get_gameObject").invoke().method("SetActive").invoke(true);
                                    newLine.method("set_useWorldSpace").invoke(true);
                                    newLine.method("get_gameObject").invoke().method("set_layer").invoke(lineRenderHolder.method("get_layer").invoke());
                                    linePool.push(newLine);
                                    finalRender = newLine;
                                }
                                finalRender.method("set_startColor").invoke(color);
                                finalRender.method("set_endColor").invoke(color);
                                finalRender.method("SetPosition").invoke(1, getTransform(playerRig).method("get_position").invoke());
                                finalRender.method("SetPosition").invoke(0, rightHandTransform.method("get_position").invoke());
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Puts tracers on your right hand. Shows only the nearest player to reduce lag."
            }),
            
            new ButtonInfo({
                buttonText: "Casual Cube ESP",
                disableMethod: () => {
                    for (let line of linePool) {
                        Destroy(line.method("get_gameObject").invoke());
                    }
                    linePool = [];
                },
                method: () => {
                    if (frameCount % 3 == 0) {
                        for (let line of linePool) {
                            line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                        }
                        const rhp = rightHandTransform.method("get_position").invoke();
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            if (!playerIsLocal(playerRig)) {
                                const color = playerRig.field("playerColor").value;
                                if (lineRenderHolder == null) {
                                    lineRenderHolder = GameObject.new("LineRender_Holder");
                                }
                                let finalRender = null;
                                let nl = false;
                                for (let line of linePool) {
                                    if (finalRender != null) continue;
                                    const lineObj = line;
                                    if (lineObj.method("get_activeInHierarchy").invoke() == false) {
                                        lineObj.method("SetActive").invoke(true);
                                        finalRender = line;
                                        break;
                                    }
                                }
                                if (finalRender == null) {
                                    nl = true;
                                    const lineHolder = GameObject.method("CreatePrimitive").invoke(3);
                                    getTransform(lineHolder).method("set_parent").invoke(getTransform(lineRenderHolder));
                                    Destroy(getComponent(lineHolder, BoxCollider));
                                    getTransform(lineHolder).method("set_localScale").invoke([0.2, 0.2, 0.2]);
                                    const shader = Shader.method("Find").overload("System.String").invoke(Il2Cpp.string("GUI/Text Shader"));
                                    getComponent(lineHolder, Renderer).method("get_material").invoke().method("set_shader").invoke(shader);
                                    if (!espCollide)
                                        Destroy(getComponent(lineHolder, BoxCollider));
                                    linePool.push(lineHolder);
                                    finalRender = lineHolder;
                                }
                                getComponent(finalRender, Renderer).method("get_material").invoke().method("set_color").invoke(color);
                                getTransform(finalRender).method("set_position").invoke(getTransform(playerRig).method("get_position").invoke());
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Puts cubes on everyone."
            }),
            
            new ButtonInfo({
                buttonText: "Casual Cuboid ESP",
                disableMethod: () => {
                    for (let line of linePool) {
                        Destroy(line.method("get_gameObject").invoke());
                    }
                    linePool = [];
                },
                method: () => {
                    if (frameCount % 3 == 0) {
                        for (let line of linePool) {
                            line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                        }
                        const rhp = rightHandTransform.method("get_position").invoke();
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            if (!playerIsLocal(playerRig)) {
                                const color = playerRig.field("playerColor").value;
                                if (lineRenderHolder == null) {
                                    lineRenderHolder = GameObject.new("LineRender_Holder");
                                }
                                let finalRender = null;
                                let nl = false;
                                for (let line of linePool) {
                                    if (finalRender != null) continue;
                                    const lineObj = line;
                                    if (lineObj.method("get_activeInHierarchy").invoke() == false) {
                                        lineObj.method("SetActive").invoke(true);
                                        finalRender = line;
                                        break;
                                    }
                                }
                                if (finalRender == null) {
                                    nl = true;
                                    const lineHolder = GameObject.method("CreatePrimitive").invoke(3);
                                    getTransform(lineHolder).method("set_parent").invoke(getTransform(lineRenderHolder));
                                    Destroy(getComponent(lineHolder, BoxCollider));
                                    getTransform(lineHolder).method("set_localScale").invoke([0.2, 0.4, 0.2]);
                                    const shader = Shader.method("Find").overload("System.String").invoke(Il2Cpp.string("GUI/Text Shader"));
                                    getComponent(lineHolder, Renderer).method("get_material").invoke().method("set_shader").invoke(shader);
                                    if (!espCollide)
                                        Destroy(getComponent(lineHolder, BoxCollider));
                                    linePool.push(lineHolder);
                                    finalRender = lineHolder;
                                }
                                getComponent(finalRender, Renderer).method("get_material").invoke().method("set_color").invoke(color);
                                getTransform(finalRender).method("set_position").invoke(getTransform(playerRig).method("get_position").invoke());
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Puts cuboids on everyone."
            }),
            
            new ButtonInfo({
                buttonText: "Casual Sphere ESP",
                disableMethod: () => {
                    for (let line of linePool) {
                        Destroy(line.method("get_gameObject").invoke());
                    }
                    linePool = [];
                },
                method: () => {
                    if (frameCount % 3 == 0) {
                        for (let line of linePool) {
                            line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                        }
                        const rhp = rightHandTransform.method("get_position").invoke();
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            if (!playerIsLocal(playerRig)) {
                                const color = playerRig.field("playerColor").value;
                                if (lineRenderHolder == null) {
                                    lineRenderHolder = GameObject.new("LineRender_Holder");
                                }
                                let finalRender = null;
                                let nl = false;
                                for (let line of linePool) {
                                    if (finalRender != null) continue;
                                    const lineObj = line;
                                    if (lineObj.method("get_activeInHierarchy").invoke() == false) {
                                        lineObj.method("SetActive").invoke(true);
                                        finalRender = line;
                                        break;
                                    }
                                }
                                if (finalRender == null) {
                                    nl = true;
                                    const lineHolder = GameObject.method("CreatePrimitive").invoke(0);
                                    getTransform(lineHolder).method("set_parent").invoke(getTransform(lineRenderHolder));
                                    Destroy(getComponent(lineHolder, BoxCollider));
                                    getTransform(lineHolder).method("set_localScale").invoke([0.2, 0.2, 0.2]);
                                    const shader = Shader.method("Find").overload("System.String").invoke(Il2Cpp.string("GUI/Text Shader"));
                                    getComponent(lineHolder, Renderer).method("get_material").invoke().method("set_shader").invoke(shader);
                                    if (!espCollide)
                                        Destroy(getComponent(lineHolder, SphereCollider));
                                    linePool.push(lineHolder);
                                    finalRender = lineHolder;
                                }
                                getComponent(finalRender, Renderer).method("get_material").invoke().method("set_color").invoke(color);
                                getTransform(finalRender).method("set_position").invoke(getTransform(playerRig).method("get_position").invoke());
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Puts spheres on everyone."
            }),
            
            new ButtonInfo({
                buttonText: "Casual Capsule ESP",
                disableMethod: () => {
                    for (let line of linePool) {
                        Destroy(line.method("get_gameObject").invoke());
                    }
                    linePool = [];
                },
                method: () => {
                    if (frameCount % 3 == 0) {
                        for (let line of linePool) {
                            line.method("get_gameObject").invoke().method("SetActive").invoke(false);
                        }
                        const rhp = rightHandTransform.method("get_position").invoke();
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            if (!playerIsLocal(playerRig)) {
                                const color = playerRig.field("playerColor").value;
                                if (lineRenderHolder == null) {
                                    lineRenderHolder = GameObject.new("LineRender_Holder");
                                }
                                let finalRender = null;
                                let nl = false;
                                for (let line of linePool) {
                                    if (finalRender != null) continue;
                                    const lineObj = line;
                                    if (lineObj.method("get_activeInHierarchy").invoke() == false) {
                                        lineObj.method("SetActive").invoke(true);
                                        finalRender = line;
                                        break;
                                    }
                                }
                                if (finalRender == null) {
                                    nl = true;
                                    const lineHolder = GameObject.method("CreatePrimitive").invoke(1);
                                    getTransform(lineHolder).method("set_parent").invoke(getTransform(lineRenderHolder));
                                    Destroy(getComponent(lineHolder, BoxCollider));
                                    getTransform(lineHolder).method("set_localScale").invoke([0.27, 0.4, 0.27]);
                                    const shader = Shader.method("Find").overload("System.String").invoke(Il2Cpp.string("GUI/Text Shader"));
                                    getComponent(lineHolder, Renderer).method("get_material").invoke().method("set_shader").invoke(shader);
                                    if (!espCollide)
                                        Destroy(getComponent(lineHolder, CapsuleCollider));
                                    linePool.push(lineHolder);
                                    finalRender = lineHolder;
                                }
                                getComponent(finalRender, Renderer).method("get_material").invoke().method("set_color").invoke(color);
                                getTransform(finalRender).method("set_position").invoke(getTransform(playerRig).method("get_position").invoke());
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Puts capsules on everyone."
            }),
        ],
        [ // Overpowered Mods [9]
            new ButtonInfo({
                buttonText: "Exit Overpowered Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),

            new ButtonInfo({
                buttonText: "Lag Gun",
                method: () => {
                    if (rightGrab) {
                        const gunData = renderGun();
                        const ray = gunData.ray;

                        if (rightTrigger) {
                            const gunTarget = getComponentInParent(ray.method("get_collider").invoke(), VRRig);
                            if (gunTarget && !gunTarget.handle.isNull() && time > lagGunDelay) {
                                if (!playerIsLocal(gunTarget)) {
                                    lagGunDelay = time + 2;

                                    const plRef = gunTarget.method("get_Creator").invoke().method("get_ActorNumber"/*GetPlayerRef"*/).invoke();
                                    const arr = Il2Cpp.array(SystemObject, 0);
                                    const rpc = FriendshipGroupDetection.field("photonView").value.method("RPC");
                                    for (let i = 0; i < 425; i++) {
                                        rpc.invoke(Il2Cpp.string("NotifyPartyMerging"), plRef, arr);
                                    }
                                    sendAllOutgoing();
                                }
                            }
                        }
                    }
                },
                isTogglable: true,
                toolTip: "Lags whoever your hand desires. May be broken."
            }),
        ],
        [ // Safety Mods [10]
            new ButtonInfo({
                buttonText: "Exit Safety Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),

            new ButtonInfo({
                buttonText: "Anti Moderator",
                isTogglable: true,
                method: () => {
                    if (frameCount % 5 != 0) {
                        const vrrigs = GorillaParent.field("vrrigs").value;
                        const vrrigtotal = vrrigs.method("get_Count").invoke();
                        let shouldLeave = false;
                        for (let i = 0; i < vrrigtotal; i++) {
                            const playerRig = vrrigs.method("get_Item").invoke(i);
                            if (playerIsLocal(playerRig)) continue;
                            const concat = String(playerRig.field("concatStringOfCosmeticsAllowed").value);
                            if (concat.includes("LBAAD.")) { shouldLeave = true; break; }; // Admin
                            if (concat.includes("LBAAK.")) { shouldLeave = true; break; }; // Stick
                            if (concat.includes("LMAPY.")) { shouldLeave = true; break; }; // Forest Guide
                        }
                        if (shouldLeave == true) {
                            let room = "";
                            try {
                                room = String(PhotonNetwork.method("get_CurrentRoom").invoke().method("get_Name").invoke());
                            } finally {
                                NetworkSystem.method("ReturnToSinglePlayer").invoke();
                            }
                            for (let i = 0; i < 10; i++) {
                                console.log("Moderator in code " + room);
                            }
                            sendNotification("Moderator in code " + room, true, 20);
                        }
                    }
                },
                toolTip: "When someone with the stick joins, you get disconnected.",
            }),
        ],

        [ // Favorite Mods [11]
            new ButtonInfo({
                buttonText: "Exit Favorite Mods",
                method: () => {
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
        ],
        
        [ // Enabled Mods [12]
            new ButtonInfo({
                buttonText: "Exit Enabled Mods",
                method: () => {                    
                    currentCategory = 0; currentPage = 0
                },
                isTogglable: false,
                toolTip: "Returns you back to the main category."
            }),
        ],

        getSoundboardButtonsVR() // Soundboard [13] - Auto-scans for MP3/WAV files
    ]
    ];

    let buttonMap: Map<string, ButtonInfo> = new Map();
    buttons.flat().forEach(button => {
        buttonMap.set(button.buttonText, button);
    });

    function getIndex(buttonText: string): ButtonInfo {
        return buttonMap.get(buttonText);
    }
    function getCategoryIndex(button: ButtonInfo): number {
        let ret = null;
        buttons.forEach((category, categoryIndex) => {
            category.forEach(categoryButton => {
                if (button == categoryButton) {
                    ret = categoryIndex;
                }
            });
        });
        return ret;
    }

    const ButtonActivation = GorillaReportButton.method("OnTriggerEnter");
    ButtonActivation.implementation = function (collider) {
        const rawName = this.method("get_name").invoke().toString();

        if (rawName.length > 1 && rawName[1] == "@") {
            if (collider == null || collider.handle == null || referenceCollider == null || referenceCollider.handle == null) {
                try { return this.method("OnTriggerEnter").invoke(collider); } catch (e) { return; }
            }
            if (collider.handle.equals(referenceCollider.handle)) {
                const goName = rawName.substring(2, rawName.length - 1);
                const _time = Time.method("get_time").invoke();

                if (_time > buttonClickDelay) {
                    buttonClickDelay = _time + 0.2;

                    const button = getIndex(goName)
                    playButtonSound();
                    if (button) {
                        if (leftGrab) {
                            toggleFavorite(button);
                            reloadMenu();
                        } else {
                            if (button.isTogglable) {
                                button.enabled = !button.enabled;

                                reloadMenu();
                                if (button?.enabled) {
                                    if (button.toolTip && buttonNotifications)
                                        sendNotification("<color=grey>[</color><color=green>ENABLE</color><color=grey>]</color> " + button.toolTip, false);
                                    button.enableMethod?.();
                                } else {
                                    if (button.toolTip && buttonNotifications)
                                        sendNotification("<color=grey>[</color><color=red>DISABLE</color><color=grey>]</color> " + button.toolTip, false);
                                    button?.disableMethod?.();
                                }

                            } else {
                                reloadMenu();
                                if (button.toolTip && buttonNotifications)
                                    sendNotification("<color=grey>[</color><color=green>ENABLE</color><color=grey>]</color> " + button.toolTip, false);
                                button?.method?.();
                            }
                            if (getCategoryIndex(button) == 12 && !enabledRecent)
                                loadEnabled();
                        }
                    }
                }
            }

            return;
        }

        return this.method("OnTriggerEnter").invoke(collider);
    };

    const VRRigOnDisable = VRRig.method("OnDisable");
    VRRigOnDisable.implementation = function () {
        if (this.handle.equals(LocalRig.handle)) {
            return;
        }

        return this.method("OnDisable").invoke();
    };

    const SendReport = MonkeAgent.method("SendReport");
    SendReport.implementation = function () {
        return;
    }

    // Custom boards
    {
        let boardIndex = 0;
        const forest = getTransform(getObject("Environment Objects/LocalObjects_Prefab/TreeRoom"));
        const childCount = forest.method("get_childCount").invoke();

        for (let i = 0; i < childCount; i++) {
            const child = forest.method("GetChild").invoke(i);
            const gameObject = child.method("get_gameObject").invoke();
            if (gameObject.method("get_name").invoke().toString().includes("UnityTempFile")) {
                boardIndex++;
                if (boardIndex == 6) {
                    boardMaterial = Material.new();
                    Material.method("CreateWithShader").invoke(boardMaterial, UberShader);

                    getComponent(gameObject, Renderer).method("set_material").invoke(boardMaterial);
                    boardMaterial.method("set_color").invoke(bgColor);
                    break;
                }
            }
        }

        let modCount = 0;
        buttons.forEach((category, categoryIndex) => {
            if (categoryIndex == 12) {
                modCount += 1;
            } else {
                modCount += category.length;
            }
        }); 

        const motdTitle = getComponent(getObject("Environment Objects/LocalObjects_Prefab/TreeRoom/motdHeadingText"), TextMeshPro);
        motdTitle.method("set_text").invoke(Il2Cpp.string("Thanks for using ii's Stupid Menu!"));

        const motdText = getComponent(getObject("Environment Objects/LocalObjects_Prefab/TreeRoom/motdBodyText"), TextMeshPro);
        motdText.method("set_fontSize").invoke(100);
        motdText.method("set_text").invoke(Il2Cpp.string(
`You are currently using build ${version}. This menu was created by iiDk (@crimsoncauldron) on Discord. There are a total of <b>${modCount}</b> mods on this menu. This menu runs completely standalone. <color=red>I, iiDk, am not responsible for any bans using this menu.</color> If you get banned while using this, it's your responsibility.`
));
    }

    const LateUpdate = GTPlayer.method("LateUpdate");

    LateUpdate.implementation = function () {
        leftPrimary = ControllerInputPoller.field("leftControllerPrimaryButton").value;
        leftSecondary = ControllerInputPoller.field("leftControllerSecondaryButton").value;

        rightPrimary = ControllerInputPoller.field("rightControllerPrimaryButton").value;
        rightSecondary = ControllerInputPoller.field("rightControllerSecondaryButton").value;

        leftGrab = ControllerInputPoller.field("leftGrab").value;
        rightGrab = ControllerInputPoller.field("rightGrab").value;

        leftTrigger = ControllerInputPoller.field("leftControllerIndexFloat").value > 0.5;
        rightTrigger = ControllerInputPoller.field("rightControllerIndexFloat").value > 0.5;

        deltaTime = Time.method("get_deltaTime").invoke();
        time = Time.method("get_time").invoke();
        frameCount++;

        if ((righthand && rightSecondary) || (!righthand && leftSecondary)) {
            if (currentNotification != "" && time > notifactionResetTime)
                reloadMenu();

            if (menu == null) {
                renderMenu();
            } else {
                recenterMenu();
            }
        } else {
            if (menu != null) {
                Destroy(menu);
                menu = null;
            }
        }

        if (menu == null) {
            if (reference != null) {
                Destroy(reference);
                reference = null;
            }
        } else {
            if (reference == null) {
                renderReference();
            }
        }

        try {
            if (GunPointer != null) {
                if (!(GunPointer.method("get_activeSelf").invoke())) {
                    Destroy(GunPointer);
                    GunPointer = null;
                }
                else
                    GunPointer.method("SetActive").invoke(false);
            }

            let lineObj = GunLine.method("get_gameObject").invoke();
            if (lineObj != null) {
                if (!(lineObj.method("get_activeSelf").invoke())) {
                    Destroy(lineObj);
                    GunLine = null;
                }
                else
                    lineObj.method("SetActive").invoke(false);
            }
        } catch { }

        try { if (gripSoundEnabled) gripSoundUpdate(); } catch (e) { }

        buttons.flat()
            .filter(button => button.enabled)
            .forEach(button => {
                if (button.method) {
                    try {
                        button.method();
                    } catch (error) {
                        console.error(`Error executing method for button '${button.buttonText || 'unnamed'}':`, error);
                        console.error('Error stack:', error.stack);
                        console.error('Button object:', button);

                        if (error.stack) {
                            const stackLines = error.stack.split('\n');
                            if (stackLines.length > 1) {
                                console.error('Error occurred at:', stackLines[1].trim());
                            }
                        }
                    }
                }
            });

        return LateUpdate.invoke();
    };

    console.log(`

     		           ┳┳┓      
     ┏┓┏┓┏┃┏┓┏┓┏┏┓╋	   ┃┃┃┏┓┏┓┓┏
     ┗ ┛┗┗┛┗ ┃ ┗┗┗┃    ┛ ┗┗ ┛┗┗┻
                              
    endercat menu ${version}
    Compiled ${new Date().toISOString()}
`);
});