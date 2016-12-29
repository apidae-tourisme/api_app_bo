require 'paperclip'

class Picture
  include Neo4j::Shared::MassAssignment
  include Neo4j::ActiveNode
  include Neo4j::Timestamps
  include Paperclip
  include Paperclip::Glue
  include PaperclipConcern

  property :img_file_name,    type: String
  property :img_content_type, type: String
  property :img_file_size,    type: Integer
  property :img_updated_at,   type: DateTime

  has_attached_file :img, {
      styles: {large: '640x640>', medium: '320x320>', thumb: '160x160>'},
      path: 'public/pictures/:timestamp/:id/:style/:basename.:extension',
      url: '/pictures/:timestamp/:id/:style/:basename.:extension'
  }
  validates_attachment_content_type :img, content_type: /\Aimage\/.*\z/, size: { in: 0..10.megabytes }

  private

  Paperclip.interpolates :timestamp do |attachment, style|
    "#{attachment.instance.created_at.year}/#{attachment.instance.created_at.month}"
  end
end