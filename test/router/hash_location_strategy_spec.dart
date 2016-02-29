library angular2.test.router.hash_location_strategy_spec;

import "package:angular2/testing_internal.dart"
    show
        AsyncTestCompleter,
        describe,
        proxy,
        it,
        iit,
        ddescribe,
        expect,
        inject,
        beforeEach,
        beforeEachProviders,
        SpyObject;
import "package:angular2/core.dart" show Injector, provide;
import "package:angular2/src/router/platform_location.dart"
    show PlatformLocation;
import "package:angular2/src/router/location_strategy.dart" show APP_BASE_HREF;
import "package:angular2/src/router/hash_location_strategy.dart"
    show HashLocationStrategy;
import "spies.dart" show SpyPlatformLocation;

main() {
  describe("HashLocationStrategy", () {
    SpyPlatformLocation platformLocation;
    HashLocationStrategy locationStrategy;
    beforeEachProviders(() => [
          HashLocationStrategy,
          provide(PlatformLocation, useClass: SpyPlatformLocation)
        ]);
    describe("without APP_BASE_HREF", () {
      beforeEach(inject([PlatformLocation, HashLocationStrategy], (pl, ls) {
        platformLocation = pl;
        locationStrategy = ls;
        platformLocation.spy("pushState");
        platformLocation.pathname = "";
      }));
      it("should prepend urls with a hash for non-empty URLs", () {
        expect(locationStrategy.prepareExternalUrl("foo")).toEqual("#foo");
        locationStrategy.pushState(null, "Title", "foo", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#foo");
      });
      it("should prepend urls with a hash for URLs with query params", () {
        expect(locationStrategy.prepareExternalUrl("foo?bar"))
            .toEqual("#foo?bar");
        locationStrategy.pushState(null, "Title", "foo", "bar=baz");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#foo?bar=baz");
      });
      it("should prepend urls with a hash for URLs with just query params", () {
        expect(locationStrategy.prepareExternalUrl("?bar")).toEqual("#?bar");
        locationStrategy.pushState(null, "Title", "", "bar=baz");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#?bar=baz");
      });
      it("should not prepend a hash to external urls for an empty internal URL",
          () {
        expect(locationStrategy.prepareExternalUrl("")).toEqual("");
        locationStrategy.pushState(null, "Title", "", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "");
      });
    });
    describe("with APP_BASE_HREF with neither leading nor trailing slash", () {
      beforeEachProviders(() => [provide(APP_BASE_HREF, useValue: "app")]);
      beforeEach(inject([PlatformLocation, HashLocationStrategy], (pl, ls) {
        platformLocation = pl;
        locationStrategy = ls;
        platformLocation.spy("pushState");
        platformLocation.pathname = "";
      }));
      it("should prepend urls with a hash for non-empty URLs", () {
        expect(locationStrategy.prepareExternalUrl("foo")).toEqual("#app/foo");
        locationStrategy.pushState(null, "Title", "foo", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#app/foo");
      });
      it("should prepend urls with a hash for URLs with query params", () {
        expect(locationStrategy.prepareExternalUrl("foo?bar"))
            .toEqual("#app/foo?bar");
        locationStrategy.pushState(null, "Title", "foo", "bar=baz");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#app/foo?bar=baz");
      });
      it("should not prepend a hash to external urls for an empty internal URL",
          () {
        expect(locationStrategy.prepareExternalUrl("")).toEqual("#app");
        locationStrategy.pushState(null, "Title", "", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#app");
      });
    });
    describe("with APP_BASE_HREF with leading slash", () {
      beforeEachProviders(() => [provide(APP_BASE_HREF, useValue: "/app")]);
      beforeEach(inject([PlatformLocation, HashLocationStrategy], (pl, ls) {
        platformLocation = pl;
        locationStrategy = ls;
        platformLocation.spy("pushState");
        platformLocation.pathname = "";
      }));
      it("should prepend urls with a hash for non-empty URLs", () {
        expect(locationStrategy.prepareExternalUrl("foo")).toEqual("#/app/foo");
        locationStrategy.pushState(null, "Title", "foo", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#/app/foo");
      });
      it("should prepend urls with a hash for URLs with query params", () {
        expect(locationStrategy.prepareExternalUrl("foo?bar"))
            .toEqual("#/app/foo?bar");
        locationStrategy.pushState(null, "Title", "foo", "bar=baz");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#/app/foo?bar=baz");
      });
      it("should not prepend a hash to external urls for an empty internal URL",
          () {
        expect(locationStrategy.prepareExternalUrl("")).toEqual("#/app");
        locationStrategy.pushState(null, "Title", "", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#/app");
      });
    });
    describe("with APP_BASE_HREF with both leading and trailing slash", () {
      beforeEachProviders(() => [provide(APP_BASE_HREF, useValue: "/app/")]);
      beforeEach(inject([PlatformLocation, HashLocationStrategy], (pl, ls) {
        platformLocation = pl;
        locationStrategy = ls;
        platformLocation.spy("pushState");
        platformLocation.pathname = "";
      }));
      it("should prepend urls with a hash for non-empty URLs", () {
        expect(locationStrategy.prepareExternalUrl("foo")).toEqual("#/app/foo");
        locationStrategy.pushState(null, "Title", "foo", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#/app/foo");
      });
      it("should prepend urls with a hash for URLs with query params", () {
        expect(locationStrategy.prepareExternalUrl("foo?bar"))
            .toEqual("#/app/foo?bar");
        locationStrategy.pushState(null, "Title", "foo", "bar=baz");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#/app/foo?bar=baz");
      });
      it("should not prepend a hash to external urls for an empty internal URL",
          () {
        expect(locationStrategy.prepareExternalUrl("")).toEqual("#/app/");
        locationStrategy.pushState(null, "Title", "", "");
        expect(platformLocation.spy("pushState"))
            .toHaveBeenCalledWith(null, "Title", "#/app/");
      });
    });
    describe("hashLocationStrategy bugs", () {
      beforeEach(inject([PlatformLocation, HashLocationStrategy], (pl, ls) {
        platformLocation = pl;
        locationStrategy = ls;
        platformLocation.spy("pushState");
        platformLocation.pathname = "";
      }));
      it("should not include platform search", () {
        platformLocation.search = "?donotinclude";
        expect(locationStrategy.path()).toEqual("");
      });
      it("should not include platform search even with hash", () {
        platformLocation.hash = "#hashPath";
        platformLocation.search = "?donotinclude";
        expect(locationStrategy.path()).toEqual("hashPath");
      });
    });
  });
}
