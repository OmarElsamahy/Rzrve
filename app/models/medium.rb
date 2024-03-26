# frozen_string_literal: true

class Medium < ApplicationRecord
  enum :media_type, { photo: 0, video: 1, pdf: 3, voice: 4 }, suffix: :media_type, default: :photo

  belongs_to :mediable, polymorphic: true
end

# == Schema Information
#
# Table name: media
#
#  id            :bigint           not null, primary key
#  file_name     :string
#  media_type    :integer          default("photo")
#  mediable_type :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  mediable_id   :bigint
#
# Indexes
#
#  index_media_on_mediable  (mediable_type,mediable_id)
#
