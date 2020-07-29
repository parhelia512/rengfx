module re.phys.rigid3d;

version (physics) {
    import re.ecs.component;
    import re.ecs.updatable;
    import re.math;
    import re.time;
    import re.core;
    import re.ng.manager;
    import re.ng.scene;
    import re.phys.collider;
    import re.util.dual_map;
    import std.math;
    import std.string : format;

    /// represents a manager for bodies in a NudgeRealm
    class PhysicsManager : Manager {
        // private NudgeRealm realm;
        // private uint item_limit = 1024;

        // /// dual map from RigidBody to physics body index
        // private DualMap!(RigidBody, uint) _body_map;

        /// checks whether this scene has a nudge manager installed
        public static bool is_installed(Scene scene) {
            auto existing = scene.get_manager!PhysicsManager();
            return !existing.isNull;
        }

        /// get the nudge manager in a scene
        public static PhysicsManager get_current(Scene scene) {
            return scene.get_manager!PhysicsManager().get;
        }

        /// enable a nudge manager in a scene
        public static void install(Scene scene) {
            auto manager = new PhysicsManager();
            // manager.allocate();
            scene.managers ~= manager;
        }

        // @property public size_t body_count() {
        //     return _body_map.count;
        // }

        /// allocate resources to run physics
        public void allocate() {
            // realm = new NudgeRealm(item_limit, item_limit, item_limit);
            // realm.allocate();
            // _body_map = new DualMap!(RigidBody, uint);
            // _box_collider_map = new DualMap!(RigidBody, ColliderRefs);
        }

        override void destroy() {
            // realm.destroy();
            // realm = null;
            // _body_map.clear();
            // _body_map = null;
        }

        override void update() {
            // TODO
        }

        /// register all colliders in this body
        private void register_colliders(RigidBody body_comp) {
            // we need to use the body's collider list to populate our internal collider registration list
            // then add the colliders to the realm

            // TODO
        }

        /// unregister all colliders in this body
        private void unregister_colliders(RigidBody body_comp) {
            import std.range : front;
            import std.algorithm : countUntil, remove;

            // for this, we need to use our internal map of a body's colliders, since its own list may have changed
            // we need to remove from the realm each collider that we internally have registered to that body
            // then clear our internal collider list
            // we don't touch the body's collider list

            // TODO
        }

        /// registers a body
        public void register(RigidBody body_comp) {
            // TODO
        }

        /// unregisters a body
        public void unregister(RigidBody body_comp) {
            // TODO
        }

        /// used to sync a body's properties with the physics system when they change
        public void refresh(RigidBody body_comp) {
            // TODO
        }
    }

    /// represents a physics body that uses the nudge physics system
    class RigidBody : Component {
        /// reference to the body id inside the nudge realm (used internally by the nudge manager)
        private uint nudge_body_id;

        /// whether this body is currently in sync with the physics system
        public bool physics_synced = false;

        private PhysicsManager mgr;

        private float _mass = 1;
        private float _inertia = 1;
        private bool _static_body = false;

        override void setup() {
            // ensure the nudge system is installed
            if (!PhysicsManager.is_installed(entity.scene)) {
                PhysicsManager.install(entity.scene);
            }

            mgr = PhysicsManager.get_current(entity.scene);

            // register with nudge
            mgr.register(this);
        }

        /// gets whether the body is static
        @property public bool is_static() {
            return _static_body;
        }

        /// sets whether the body is static
        @property public bool is_static(bool value) {
            _static_body = value;
            mgr.refresh(this);
            return value;
        }

        /// gets the body's mass
        @property public float mass() {
            return _mass;
        }

        /// sets the body's mass
        @property public float mass(float value) {
            _mass = value;
            mgr.refresh(this);
            return value;
        }

        /// gets the body's moment of inertia
        @property public float inertia() {
            return _inertia;
        }

        /// sets the body's moment of inertia
        @property public float inertia(float value) {
            _inertia = value;
            mgr.refresh(this);
            return _inertia;
        }

        /// used to notify the physics engine to update colliders if they have changed
        public void sync_colliders() {
            mgr.refresh(this);
        }

        override void destroy() {
            mgr.unregister(this);
        }
    }

    @("phys-rigid3d-basic") unittest {
        import re.ng.scene : Scene2D;
        import re.util.test : test_scene;

        class TestScene : Scene2D {
            override void on_start() {
                auto nt = create_entity("block");
                // add nudge physics
                nt.add_component(new RigidBody());
            }
        }

        auto test = test_scene(new TestScene());
        test.game.run();

        // check conditions

        test.game.destroy();
    }

    // @("phys-rigid3d-lifecycle") unittest {
    //     import re.ng.scene : Scene2D;
    //     import re.util.test : test_scene;
    //     import re.ecs.entity : Entity;

    //     class TestScene : Scene2D {
    //         private Entity nt1;

    //         override void on_start() {
    //             nt1 = create_entity("one");
    //             nt1.add_component(new RigidBody());
    //             auto nt2 = create_entity("two");
    //             nt2.add_component(new RigidBody());
    //             auto nt3 = create_entity("three");
    //             nt3.add_component(new RigidBody());
    //         }

    //         public void kill_one() {
    //             nt1.destroy();
    //         }
    //     }

    //     auto test = test_scene(new TestScene());
    //     test.game.run();

    //     // check conditions
    //     auto mgr = test.scene.get_manager!PhysicsManager;
    //     assert(!mgr.isNull);
    //     assert(mgr.get.body_count == 3, "physics body count does not match");

    //     (cast(TestScene) test.scene).kill_one();
    //     assert(mgr.get.body_count == 2, "physics body was not unregistered on component destroy");

    //     test.game.destroy();
    // }
}