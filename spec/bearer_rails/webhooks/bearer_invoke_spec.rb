# frozen_string_literal: true

require "spec_helper"

class TestIntId < BearerRails::Webhooks::Base
  def call
    "whatever"
  end
end
RSpec.describe BearerRails::BearerInvoke do
  before do
    Bearer::Configuration.secret = "yZ23GR954QN4/QpvJ+OI78Iz/YrAeylM"
  end

  let(:my_class) do
    Class.new do
      include BearerRails::BearerInvoke
    end
  end
  let(:sha) do
    # in node: crypto.createHmac("sha256", "yZ23GR954QN4/QpvJ+OI78Iz/YrAeylM").update(new Buffer("hello", "utf8")).digest('hex')
    "72fcebeeba184663888d01eccf3be533aded59ae18959bb7e7a61d073577fda2"
  end
  it "allows to invoke class call based on convention" do
    expect(my_class.invoke(integration_id: "test_int_id", org_id: "org-id", origin: "origin", sha: sha, body: "hello")).to eq("whatever")
  end
end
