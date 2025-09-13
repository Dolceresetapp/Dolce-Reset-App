'use client';

import React from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { CheckCircle, Download, Mail } from 'lucide-react';

export default function CheckoutSuccessPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-100 flex items-center justify-center p-4">
      <Card className="w-full max-w-lg shadow-lg">
        <CardContent className="pt-8 text-center">
          <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <CheckCircle className="w-10 h-10 text-green-600" />
          </div>
          
          <h1 className="text-3xl font-bold text-gray-900 mb-4">
            Payment Successful!
          </h1>
          
          <p className="text-gray-600 mb-8">
            Thank you for your purchase. Your order has been confirmed and you'll receive 
            a confirmation email shortly with all the details.
          </p>

          <div className="bg-gray-50 rounded-lg p-4 mb-6">
            <h3 className="font-semibold text-gray-900 mb-2">Order Details</h3>
            <div className="text-sm text-gray-600 space-y-1">
              <p>Order #: <span className="font-mono">ORD-2024-001</span></p>
              <p>Total: <span className="font-semibold">$43.18 USD</span></p>
              <p>Payment Method: <span className="font-semibold">•••• 4242</span></p>
            </div>
          </div>

          <div className="space-y-3">
            <Button className="w-full" variant="outline">
              <Mail className="w-4 h-4 mr-2" />
              Resend Confirmation Email
            </Button>
            
            <Button className="w-full" variant="outline">
              <Download className="w-4 h-4 mr-2" />
              Download Invoice
            </Button>
            
            <Button 
              onClick={() => window.location.href = '/'} 
              className="w-full bg-green-600 hover:bg-green-700"
            >
              Continue to Dashboard
            </Button>
          </div>

          <div className="mt-6 pt-6 border-t border-gray-200">
            <p className="text-xs text-gray-500">
              Need help? Contact our support team at{' '}
              <a href="mailto:support@yoursite.com" className="text-blue-600 hover:underline">
                support@yoursite.com
              </a>
            </p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}