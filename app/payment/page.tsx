'use client';

import React, { useState, useEffect } from 'react';
import { loadStripe, StripeElementsOptions } from '@stripe/stripe-js';
import {
  Elements,
  PaymentElement,
  useStripe,
  useElements
} from '@stripe/react-stripe-js';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';
import { Badge } from '@/components/ui/badge';
import { CreditCard, Lock, CheckCircle, Loader2, ShoppingBag } from 'lucide-react';
import DiscountBanner from '@/components/timer';
import Image from 'next/image';
import Link from 'next/link';
import TestimonialSlider from '@/components/testimonial-slider';


const PUBLIC_STRIPE_PUBLISHABLE_KEY = "pk_live_51RVnBBBcIsUXPnbFNO5JrDfHNP28gqlZ3HExjeNJbG5fszbKfQvZJY6saCUs1kd2C1WoBgFGNLYm9c7KZpgPSwpX00cTZZy0hy"
// Initialize Stripe
const stripePromise = loadStripe(PUBLIC_STRIPE_PUBLISHABLE_KEY);
// const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || '');

// Mock order data
const orderData = {
  items: [
    { id: 1, name: 'Premium Subscription', price: 49.00, quantity: 1 },
    { id: 2, name: 'Setup Fee', price: 0, quantity: 1 }
  ],
  subtotal: 49.00,
  tax: 0,
  total: 4900,
  currency: 'eur'
};

interface CheckoutFormProps {
  clientSecret: string;
  customerId: string;
}

function CheckoutForm({ clientSecret, customerId }: CheckoutFormProps) {
  const stripe = useStripe();
  const elements = useElements();
  const [isProcessing, setIsProcessing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!stripe || !elements) return;

    setIsProcessing(true);

    const { error, setupIntent } = await stripe.confirmSetup({
      elements,
      confirmParams: {
        return_url: window.location.origin + "/payment-success",
      },
      redirect: "if_required",
    });

    if (error) {
      setError(error.message || "Setup failed");
      setIsProcessing(false);
      return;
    }

    if (setupIntent?.status === "succeeded") {
      // Card saved successfully ✅
      // Here you can:
      // 1. Create a subscription with trial server-side using the saved payment method
      // 2. Wait 3 days, then start billing automatically
      console.log(setupIntent);
      const res = await fetch("/api/create-payment-intent/create-subscription-with-trial", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          customer_id: customerId,
          payment_method_id: setupIntent.payment_method,
          trial_days: 3
        })
      });

      const data = await res.json();
      if (data.error) {
        setError(data.error);
      } else {
        window.location.href = "/payment-success";
      }
    }
  };


  return (
    <div className="min-h-screen max-w-lg mx-auto bg-gradient-to-br from-blue-50 to-indigo-100 py-8 px-4">
      <div className="max-w-6xl mx-auto">
        <DiscountBanner />


        <Image src="/custom/payment.png" alt="Logo" width={5000} height={5000} quality={100} className='w-full my-10' />

        {/* Yearly Pricing Card */}
        <div className="relative mt-6n py-2 bg-gradient-to-r from-pink-50 to-rose-50 rounded-2xl p-5 border-2 border-pink-200 text-center">
          <Badge className="absolute -top-3 left-0 left-5 bg-black text-white px-3 py-0 rounded-full">
            3 GIORNI GRATIS
          </Badge>

          <div className="flex flex-col items-center">
            <div className="flex items-end space-x-2">
              <span className="text-3xl font-bold text-gray-800">€3,90</span>
              <span className="text-gray-600 text-lg">/mese</span>
            </div>
            <p className="text-sm text-gray-600 mt-1">
              Pagato annuo a €47
            </p>
            <Badge className=" mt-2 bg-yellow-500 text-black">Ultimi 2 posti disponibili per questo mese</Badge>
          </div>
        </div>

        <br />

        <div className="grid lg:grid-cols-1 gap-8 bg-white">
          <div className="p-5">
            <h1 className="text-2xl font-bold text-gray-900 mb-2">Addebito dopo le prove gratuite NON ora</h1>
            <p className="text-gray-600">Scegli come pagare</p>
            <ul className="list-disc pl-4">
              <li>Prezzo al mese: <span className="text-green-600">3,90 euro</span></li>
              <li>Totale: 47 al anno</li>
              <li>Hai risparmiato <span className="text-green-600">47,00 euro</span> (50% in meno)</li>
            </ul>
          </div>
          {/* Checkout Form */}
          <div className="" id='checkout-form'>
            <CardContent className="space-y-6">
              <form onSubmit={handleSubmit} className="space-y-6">
                {/* Payment Element */}
                <div className="space-y-2">
                  <div className="p-4 border border-gray-300 rounded-lg bg-white focus-within:ring-2 focus-within:ring-blue-500 focus-within:border-blue-500 transition-all">
                    <PaymentElement
                      options={{
                        layout: 'tabs',
                        fields: {
                          billingDetails: {
                            name: 'auto',
                            email: 'auto',
                            phone: 'auto', // not "never"
                            address: {
                              country: 'auto',
                              postalCode: 'auto',
                              line1: 'auto',
                              line2: 'auto',
                              city: 'auto',
                              state: 'auto'
                            }
                          }
                        }

                      }}
                    />
                  </div>
                </div>

                {error && (
                  <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                    <p className="text-red-600 text-sm">{error}</p>
                  </div>
                )}

                <Button
                  type="submit"
                  disabled={!stripe || isProcessing}
                  className="w-full h-12 text-base font-semibold bg-pink-600 hover:bg-pink-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                >
                  {isProcessing ? (
                    <>
                      <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                      Attivazioneo...
                    </>
                  ) : (
                    <>
                      <Lock className="w-4 h-4 mr-2" />
                      Avvia prova gratuita
                    </>
                  )}
                </Button>

                <div className="flex flex-col gap-2 items-center justify-center space-x-4 text-sm text-gray-500">
                  <p>Transazione protetta – nessun dato salvato</p>
                <Image src="https://www.italytoner.it/img/pagamentisicuri1.png" alt="Logo" width={50} height={50} quality={100} className='w-36' />
                </div>
              </form>
            </CardContent>
          </div>

          <TestimonialSlider />
          <Image src="/custom/doctor.png" alt="Logo" width={500} height={500} className='w-full my-10' />
          <Link href="#checkout-form">
            <Button className="w-full h-12 text-base font-semibold bg-pink-600 hover:bg-pink-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all">Inizia prova gratuita</Button>
          </Link>
        </div>
      </div>
    </div>
  );
}

export default function CheckoutPage() {
  const [clientSecret, setClientSecret] = useState<string>('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [customerId, setCustomerId] = useState<string>('');

  useEffect(() => {
    const fetchClientSecret = async () => {
      try {
        const response = await fetch('/api/create-payment-intent', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            amount: orderData.total,
            currency: orderData.currency,
            metadata: {
              order_id: `order_${Date.now()}`,
              items: JSON.stringify(orderData.items.map(item => ({
                name: item.name,
                quantity: item.quantity,
                price: item.price
              })))
            }
          })
        });

        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.error || 'Failed to create payment intent');
        }

        const { client_secret, customer_id } = await response.json();
        setClientSecret(client_secret);
        setCustomerId(customer_id);
        setLoading(false);
      } catch (error) {
        console.error('Error creating payment intent:', error);
        setError(error instanceof Error ? error.message : 'Failed to initialize payment');
        setLoading(false);
      }
    };

    fetchClientSecret();
  }, []);

  const stripeElementsOptions: StripeElementsOptions = {
    clientSecret,
    appearance: {
      theme: 'stripe',
      variables: {
        colorPrimary: '#2563eb',
        colorBackground: '#ffffff',
        colorText: '#1f2937',
        colorDanger: '#ef4444',
        borderRadius: '8px',
      },
    },
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <div className="text-center">
          <Loader2 className="w-8 h-8 animate-spin text-blue-600 mx-auto mb-4" />
          <p className="text-gray-600">Setting up your checkout...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
        <Card className="w-full max-w-md shadow-lg">
          <CardContent className="pt-8 text-center">
            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <CreditCard className="w-8 h-8 text-red-600" />
            </div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Payment Setup Failed</h2>
            <p className="text-gray-600 mb-6">{error}</p>
            <Button onClick={() => window.location.reload()} className="w-full">
              Try Again
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  if (!clientSecret) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <div className="text-center">
          <Loader2 className="w-8 h-8 animate-spin text-blue-600 mx-auto mb-4" />
          <p className="text-gray-600">Initializing payment...</p>
        </div>
      </div>
    );
  }

  return (
    <Elements stripe={stripePromise} options={stripeElementsOptions}>
      <CheckoutForm clientSecret={clientSecret} customerId={customerId} />
    </Elements>
  );
}