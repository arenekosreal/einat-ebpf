include $(TOPDIR)/rules.mk

PKG_NAME:=einat-ebpf
PKG_VERSION:=0.1.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/EHfive/$(PKG_NAME)/tar.gz/refs/tags/v$(PKG_VERSION)?
PKG_HASH:=e980567667720161f69415d752f1ed23c7b8a1ae82341bef0522e2d432d450a1

PKG_LICENSE:=GPL-2.0-or-later GPL-2.0-only
PKG_LICENSE_FILE:=LICENSE

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=rust/host

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/bpf.mk
# TODO: replace rust-package.mk with relative path
#include ../../lang/rust/rust-package.mk
include $(TOPDIR)/feeds/packages/lang/rust/rust-package.mk

KERNEL_DEPENDS:= \
	+@KERNEL_DEBUG_INFO_BTF \
	+kmod-sched-bpf

define Package/einat-ebpf
	PROVIDES:=einat
	CATEGORY:=Network
	SUBMENU:=Routing and Redirection
	DEPENDS:=$(RUST_ARCH_DEPENDS) $(KERNEL_DEPENDS) $(BPF_DEPENDS) +libelf1 +zlib
	TITLE:=eBPF-based Endpoint-Independent NAT
	URL:=https://github.com/EHfive/einat-ebpf
	USERID:=einat:einat
	MENU:=1
	MAINTAINER:=
endef

define Package/einat-ebpf/conffiles
/etc/einat.toml
endef

define Package/einat-ebpf/description
This eBPF application implements an "Endpoint-Independent Mapping" and
"Endpoint-Independent Filtering" NAT(network address translation) on
TC egress and ingress hooks.
endef

define Package/einat-ebpf/config
	source "$(SOURCE)/Config.in"
endef

define Package/einat-ebpf/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/einat $(1)/usr/bin

	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/config.sample.toml $(1)/etc/einat.toml

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/einat-ebpf.init $(1)/etc/init.d/einat

	$(INSTALL_DIR) $(1)/etc/capabilities
	$(INSTALL_CONF) ./files/capabilities.json $(1)/etc/capabilities/einat.json
endef

ifeq ($(CONFIG_EINAT_EBPF_IPV6),y)
	RUST_PKG_FEATURES+=ipv6,
endif

$(eval $(call RustBinPackage,einat-ebpf))
$(eval $(call BuildPackage,einat-ebpf))