# frozen_string_literal: true

require 'spec_helper'

module ActivityPub
  module Helpers
    RSpec.describe Requests do
      describe '.verify_signature' do
        let(:public_key ) {
          <<~KEY
            -----BEGIN PUBLIC KEY-----
            MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCFENGw33yGihy92pDjZQhl0C3
            6rPJj+CvfSC8+q28hxA161QFNUd13wuCTUcq0Qd2qsBe/2hFyc2DCJJg0h1L78+6
            Z4UMR7EOcpfdUE9Hf3m/hs+FUR45uBJeDK1HSFHD8bHKD6kv8FPGfJTotc+2xjJw
            oYi+1hqp1fIekaxsyQIDAQAB
            -----END PUBLIC KEY-----
          KEY
        }

        let (:request) {
          req = Class.new(Rack::Request)
          req.include described_class
          req.new({})
        }

        # https://tools.ietf.org/html/draft-cavage-http-signatures-11#appendix-C.3
        it 'All Headers Test' do
          allow(request).to receive(:request_method).and_return('POST')
          allow(request).
            to receive(:each_header).
            and_return(
                'Host' => 'example.com',
                'Date' => 'Sun, 05 Jan 2014 21:31:40 GMT',
                'Content-Type' => 'application/json',
                'Digest' =>
                  'SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=',
                'Content-Length' => '18',
                'Signature' => 'keyId="https://example.com",'\
                  'algorithm="rsa-sha256",' \
                  'created=1402170695,'\
                  'expires=1402170699,' \
                  'headers="(request-target) (created) (expires)' \
                    'host date content-type digest content-length",' \
                  'signature="vSdrb+dS3EceC9bcwHSo4MlyKS59iFIrhgYkz8+oVLEEzmYZZvRs' \
                    '8rgOp+63LEM3v+MFHB32NfpB2bEKBIvB1q52LaEUHFv120V01IL+TAD48XaERZF' \
                    'ukWgHoBTLMhYS2Gb51gWxpeIq8knRmPnYePbF5MOkR0Zkly4zKH7s1dE="'
              )
          allow(request).
            to receive(:fullpath).
            and_return('/foo?param=value&pet=dog')

          http_client = class_double(ActivityPub::Clients::ActivityPub)
          response = instance_double(Rack::Response)
          actor = double(::ActivityStreams::Actor)
          allow(actor).to receive(:publicKey).and_return(
            'publicKeyPem' => public_key
          )
          allow(http_client).to receive(:get).and_return(actor)
          allow(ActivityPub::Clients).
            to receive(:activity_pub).
            and_return(http_client)

          expect(request.verify_signature).to eq(true)
        end
      end
    end
  end
end
