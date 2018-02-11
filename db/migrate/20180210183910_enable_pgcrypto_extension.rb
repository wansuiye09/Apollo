class EnablePgcryptoExtension < ActiveRecord::Migration[5.1]
  def change
    extension_name = 'pgcrypto'
    enable_extension(extension_name) unless extension_enabled?(extension_name)
  end
end
